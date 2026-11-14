class_name wall extends Node2D
@export var rect: TextureRect
@export var maxUnits: int ##not currently in use.
var unitList: Array = []
var listShells = [[],[],[],[]]
var mouseHovering = false

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if mouseHovering && INVGLOBAL.mouseIsHovering:
		modulate = Color.GREEN
	else:
		modulate = Color.WHITE
	
	for unit in unitList:
		if unitList == []:
			return
		
		if unit.target.isDead != null:
			return
			
		for shellList in listShells:
			if shellList == []:
				pass
			else:
				unit.setTarget(shellList.pop_back())

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
	mouseHovering = true
	print(mouseHovering)


func _on_wall_collider_mouse_exited() -> void:
	mouseHovering = false
