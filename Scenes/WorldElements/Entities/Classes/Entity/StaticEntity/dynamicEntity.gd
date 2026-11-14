class_name DynamicEntity extends Entity

@export var motionComponent: MotionComponent
@export var healthComponent: HealthComponent
@export var collisionComponent: CollisionComponent
@export var universalEffectsComponent: AnimationPlayer
var state: STATE = STATE.IDLE
enum STATE{
	IDLE,
	RUN,
	ATTACK,
}

func _ready() -> void:
	healthComponent.damaged.connect(_on_damaged)
	healthComponent.healed.connect(_on_healed)
	healthComponent.died.connect(_on_died)

func _on_died() -> void:
	Global.entityCount -= 1
	print("Died: ", name)
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
