class_name SmallGoblin extends DynamicEntity

@export var attackComponent: AttackComponent
@export var sprite: AnimatedSprite2D


var state: STATE = STATE.IDLE

func _physics_process(_delta: float) -> void:
	_queryState()

func setState(newstate: STATE)->void:
	state = newstate

func _queryState()->void:
	match state:
		STATE.IDLE:
			sprite.play("idle")
			collisionComponent.pushable = true
			collisionComponent.canPush = false
		STATE.ATTACK:
			sprite.play("attack")
			collisionComponent.pushable = false
			collisionComponent.canPush = true
		STATE.RUN:
			sprite.play("run")
			collisionComponent.pushable = true
			collisionComponent.canPush = true


func _on_sprite_2d_animation_finished() -> void:
	_queryState()
