class_name Wall extends Node2D
@export var sprite: Sprite2D
@export var maxUnits: int ##not currently in use.
var unitList: Array = []
var listShells = [[],[],[],[]]
var mouseHovering = false

func addUnit(packedScene: PackedScene)->void:
	var unit = packedScene.instantiate()
	unitList.append(unit)

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if INVGLOBAL.wallHovered == self:
		modulate = Color.GREEN
	else:
		modulate = Color.WHITE
	
	for unit: Entity in unitList:
		if unitList == []:
			return
		
		if unit.target != null: #might need to change to healthComponent.isDead
			return
		
		for shellList in listShells:
			if shellList != []:
				unit.setTarget(shellList[randi_range(0, shellList.size() - 1)])

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



func _on_wall_collider_mouse_entered() -> void:
	INVGLOBAL.wallHovered = self
	
func _on_wall_collider_mouse_exited() -> void:
	INVGLOBAL.wallHovered = null
