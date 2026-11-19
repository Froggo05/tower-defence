class_name Wall extends Node2D

@export var sprite: Sprite2D
@export var maxUnits: int
@export var unitManager: Node2D
var unitList: Array = []
var listShells = [[],[],[],[]]

func addUnit(newEntityName: String)->void:
	if unitList.size() < maxUnits:
		var unit = Global.generateEntity(newEntityName)
		unitList.append(unit) 
		#unitManager.add_child(unit)
		updateUnitDistribution()
		return
	
	push_warning("Trying to add to a full wall.")

func updateUnitDistribution()->void:
	var rect: Rect2 = Rect2(sprite.global_position, sprite.texture.get_size())
	var x
	var y
	var i = 0
	for unit in unitList:
		if rect.size.x > rect.size.y:
			x = i* rect.size.x/unitList.size()
			y =  0.0 #rect.size.x / 2
		else:
			x =  0.0 #rect.size.x / 2
			y = i* rect.size.y/unitList.size()
			
		unit.global_position = to_global(Vector2(x,y)) 
		i += 1

func updateUnitTarget()->void:
	for unit: Entity in unitList:
		if unitList == []:
			return
		
		if unit.target != null: #might need to change to healthComponent.isDead
			return
		
		##	for enemy add a count of whos targeting to that enemy and if its too high 
		##	try a different one but if the other ones are too high just dont worry?
		
		for shellList in listShells:
			if shellList != []:
				unit.setTarget(shellList[randi_range(0, shellList.size() - 1)])
				break

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if INVGLOBAL.wallHovered == self:
		modulate = Color.GREEN
	else:
		modulate = Color.WHITE
		
	updateUnitTarget()
	


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
