extends State

@onready var unit: Unit = owner

func _enter() -> void:
	unit.navAgent.target_position = unit.targetPosition

func _exit() -> void:
	return

func _state_input(_event: InputEvent) -> void:
	return

func _update(_delta: float ) -> void:
	return
