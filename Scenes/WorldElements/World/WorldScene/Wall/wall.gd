class_name Wall extends Node2D

@export var sprite: Sprite2D
@export var maxUnits: int
var unitList: Array = []
var listShells = [[],[],[],[]]

func addUnit(newEntityName: String)->bool:
	if unitList.size() < maxUnits:
		var unit = Global.generateEntity(newEntityName)
		
		if unit is not RangedEntity:
			# theoretically should kill the entity but is fine because no reference it gets freed anyway
			unit.queue_free()
			return false
		
		unitList.append(unit) 
		#unitManager.add_child(unit)
		updateUnitDistribution()
		return true
	
	push_warning("Trying to add to a full wall.")
	return false

func updateUnitDistribution()->void:
	var x
	var y
	var spriteSize = sprite.texture.get_size()
	var xoffset = spriteSize.x / 2
	var i = 0
	for unit in unitList:
		if unitList.size() == 1:
			unit.global_position = to_global(Vector2.ZERO)
			return
		
		var a = spriteSize.x / (unitList.size() - 1)
		x = a * i - xoffset
		y = 0 
			
		unit.global_position = to_global(Vector2(x,y))
		i += 1

func updateUnitsTarget()->void:
	if unitList == []:
		return
	
	for unit: Entity in unitList:
		if unit.rangedAttackComponent.target != null: #might need to change to healthComponent.isDead
			continue
		##	for enemy add a count of whos targeting to that enemy and if its too high 
		##	try a different one but if the other ones are too high just dont worry?
		if unit is not RangedEntity:
			continue 
	
		for shellList in listShells:
			if shellList == []:
				continue
			
			unit.rangedAttackComponent.setTarget(shellList[randi_range(0, shellList.size() - 1)])

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if INVGLOBAL.wallHovered == self:
		modulate = Color.GREEN
	else:
		modulate = Color.WHITE
		
	updateUnitsTarget()
	


func _on_shell_0_area_entered(area: Area2D) -> void:
	if area is HealthComponent:
		listShells[0].append(area)
func _on_shell_0_area_exited(area: Area2D) -> void:
	if area is HealthComponent:
		listShells[0].erase(area)

func _on_shell_1_area_entered(area: Area2D) -> void:
	if area is HealthComponent:
		listShells[1].append(area)
func _on_shell_1_area_exited(area: Area2D) -> void:
	if area is HealthComponent:
		listShells[1].erase(area)

func _on_shell_2_area_entered(area: Area2D) -> void:
	if area is HealthComponent:
		listShells[2].append(area)
func _on_shell_2_area_exited(area: Area2D) -> void:
	if area is HealthComponent:
		listShells[2].erase(area)

func _on_shell_3_area_entered(area: Area2D) -> void:
	if area is HealthComponent:
		listShells[3].append(area)
func _on_shell_3_area_exited(area: Area2D) -> void:
	if area is HealthComponent:
		listShells[3].erase(area)
