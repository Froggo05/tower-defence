class_name orcBase extends Enemy

@export var stateMachine: StateMachine
@export var aniSprite: AnimatedSprite2D
@export var aniPlayer: AnimationPlayer

var collidingWith: Array = []

func _ready() -> void:
	_connectSignals()



func _physics_process(delta: float) -> void:
	_updateRotation()
	_updateCollisions()

func _updateCollisions()->void:
	for area in collidingWith:
		if area.Parent is orcBase:
			var dir = global_position.direction_to(area.Parent.global_position)
			var strength = 10
			var pushImpulse = strength * dir
			area.getPushed(pushImpulse)
			print("Pushing Body: ", area.Parent.name, " With Force: ", pushImpulse)

func _connectSignals()->void:
	stateMachine.changingState.connect(reactToState)

func push(pushimpulse: Vector2)->void:
	velocity += pushimpulse


func _updateRotation()->void:
	rotation = velocity.normalized().angle() + deg_to_rad(90) #up != forward, +x actually is forward

func reactToState(stateName: String)->void: #signal response
	match stateName:
		"Attack":
			aniSprite.play(stateName)
			aniPlayer.play(stateName)
			await aniSprite.animation_finished
			aniSprite.play("Idle")
			return
		"Idle":
			aniSprite.play(stateName)
			aniPlayer.play(stateName)
			return
		"Walk":
			aniSprite.play(stateName)
			aniPlayer.play(stateName)
			return

func _on_hitbox_area_entered(area: Area2D) -> void:
	print(area.name)
	if area is EnemyHitbox:
		collidingWith.append(area)

func _on_hitbox_area_exited(area: Area2D) -> void:
	if area is EnemyHitbox:
		collidingWith.erase(area)
