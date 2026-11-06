extends StaticEntity

@export var motionComponent: MotionComponent
@export var universalEffectsComponent: AnimationPlayer

func _on_died() -> void:
	queue_free()

func _on_damaged(healthLost: float) -> void:
	universalEffectsComponent.play("damaged")

func _on_healed(healthGained: float) -> void:
	universalEffectsComponent.play("healing")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		motionComponent.setTarget(get_global_mouse_position())
