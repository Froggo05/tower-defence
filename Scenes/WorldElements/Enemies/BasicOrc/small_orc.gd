class_name orcBase extends Enemy

@export var stateMachine: StateMachine
@export var aniSprite: AnimatedSprite2D
@export var aniPlayer: AnimationPlayer

var collidingWith: Array = []

func _ready() -> void:
	_connectSignals()



func _physics_process(delta: float) -> void:
	pass

func _updateCollisions()->void:
	for body: orcBase in collidingWith:
		var dir = global_position.direction_to(body.global_position)
		var strength = 0.5
		var pushImpulse = strength * dir
		body.push(pushImpulse)

func _connectSignals()->void:
	stateMachine.changingState.connect(reactToState)

func push(pushimpulse: Vector2)->void:
	velocity += pushimpulse

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


func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		collidingWith.append(body)

func _on_body_exited(body: Node) -> void:
	if body is Enemy:
		collidingWith.erase(body)
