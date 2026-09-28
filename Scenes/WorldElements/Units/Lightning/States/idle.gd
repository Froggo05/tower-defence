extends State

#Is in this state on conditions
# - Was just spawned in
# - At targetLocation and no enemy in range
# 	- How would it know where to face? away from core? get direction using pos - pos2 and use the negative?

# if not at ataget pos set to WalkToPos
@onready var unit: Unit = owner

func _enter() -> void:
	if unit.global_position != unit.targetPosition:
		finished.emit("GoToPos")
	else:
		unit.aniSprite.play("idle")

func _exit() -> void:
	return

func _state_input(_event: InputEvent) -> void:
	return

func _update(_delta: float ) -> void:
	return
