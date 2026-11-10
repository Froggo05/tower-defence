class_name SmallGoblin extends DynamicEntity

@export var attackComponent: AttackComponent
@export var sprite: AnimatedSprite2D

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
			motionComponent.canRotate = true
		STATE.ATTACK:
			sprite.play("attack")
			collisionComponent.pushable = false
			collisionComponent.canPush = true
			motionComponent.canRotate = false
		STATE.RUN:
			sprite.play("run")
			collisionComponent.pushable = true
			collisionComponent.canPush = true
			motionComponent.canRotate = true


func _on_sprite_2d_animation_finished() -> void:
	_queryState()
