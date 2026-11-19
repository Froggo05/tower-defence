class_name Wall extends Node2D
@export var sprite: Sprite2D
@export var maxUnits: int ##not currently in use.
var unitList: Array = []
var listShells = [[],[],[],[]]

func addUnit(newUnitName: String)->void:
	var newUnitPosition = updateUnitDistribution(unitList.size() + 1)
	var unit = 	Global.summonEntity(newUnitPosition, newUnitName)
	unitList.append(unit) 

func updateUnitDistribution(amount: int)->Vector2:
	#var center = 0 #cant figure it out rn. ive done it before but its slipped my mind. something about finding the distribution if points by fraction of length and then multiply by i to get the intervals. After just return an array of all of the positions. or just update the units in the forloop
	#sprite.get_rect() /2
	return Vector2.ZERO

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
