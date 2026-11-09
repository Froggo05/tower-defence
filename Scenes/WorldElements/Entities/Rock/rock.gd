class_name Rock extends StaticEntity

@export var motionComponent: MotionComponent
@export var universalEffectsComponent: AnimationPlayer
@export var animationPlayer: AnimationPlayer
@export var collisionComponent: CollisionComponent
@export var tempLabel: Label

func _ready() -> void:
	tempLabel.text = self.name

func _on_died() -> void:
	queue_free()

@warning_ignore("unused_parameter")
func _on_damaged(healthLost: float) -> void:
	universalEffectsComponent.play("damaged")

@warning_ignore("unused_parameter")
func _on_healed(healthGained: float) -> void:
	universalEffectsComponent.play("healing")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Rightclick"):
		motionComponent.setTarget(get_global_mouse_position())

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if motionComponent.atTarget:
		collisionComponent.pushable = false
		collisionComponent.canPush = false
	else:
		collisionComponent.pushable = true
		collisionComponent.canPush = true
