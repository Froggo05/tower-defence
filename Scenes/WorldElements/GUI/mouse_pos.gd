extends Label
func _physics_process(delta: float) -> void:
	text = "Mouse Pos: " + str(get_global_mouse_position())
