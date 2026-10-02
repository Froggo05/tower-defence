extends RigidBody2D
class_name Enemy
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var health = 1.0
var damage = 2.0
var isTargeted: bool = false
var direction: Vector2 = Vector2(1.0, 0)

var clock: float = 0.0
var moveInterval: float = 0.25
var canMove: bool = true
var impulse: float = 25.0
var frictionConstant: float = 5.0
var movementToggle: bool = true
var velocity: Vector2 = Vector2.ZERO

@export var stateMachine: StateMachine
@export var aniSprite: AnimatedSprite2D
@export var aniPlayer: AnimationPlayer
@export var navAgent: NavigationAgent2D

var collidingWith: Array = []


func timer(delta)->void:
	if canMove:
		return
	
	if clock >= moveInterval:
		clock -= moveInterval
		canMove = true
		return
	
	clock += delta


func _process(delta: float) -> void:
	if health <= 0:
		Global.enemyCount -= 1
		queue_free()

	timer(delta)


func attack(target: Area2D)-> void:
	target._takeDamage(damage)


func _takeDamage(incomingDamage: float)-> void:
	health -= incomingDamage


func updatePosition(delta)->void:
	applyFriction(delta)
	position += velocity * delta
	
	applyImpulse(delta)


func applyImpulse(_delta)->void:
	if canMove:
		velocity += impulse * direction
		canMove = false


func applyFriction(delta)->void:
	velocity = lerp(velocity, Vector2.ZERO, frictionConstant * delta)


func _target()->void:
	isTargeted = true


func _attack_range_entered(area: Area2D) -> void:
	#attack the hitbox in range
	if area.has_method("_getHit"):
		sprite.play()
		area._getHit(damage)


func _ready() -> void:
	_connectSignals()

func _physics_process(delta: float) -> void:
	_updateRotation()
	_updateCollisions()
	
	updatePosition(delta)
	
	if move_and_collide(velocity * delta):
		velocity /= 1.25
		canMove = false
		movementToggle = false

func _updateCollisions()->void:
	for area in collidingWith:
		if area.Parent is orcBase:
			var dir = global_position.direction_to(area.Parent.global_position)
			var strength = 2
			var pushImpulse = strength * dir
			area.getPushed(pushImpulse)
			#print("Pushing Body: ", area.Parent.name, " With Force: ", pushImpulse)

func _connectSignals()->void:
	stateMachine.changingState.connect(_reactToStateChange)

func push(pushimpulse: Vector2)->void:
	velocity += pushimpulse


func _updateRotation()->void:
	rotation = velocity.normalized().angle() + deg_to_rad(90) #up != forward, +x actually is forward

func _reactToStateChange(stateName: String)->void: #signal response
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
	if area is EnemyHitbox:
		collidingWith.append(area)

func _on_hitbox_area_exited(area: Area2D) -> void:
	if area is EnemyHitbox:
		collidingWith.erase(area)
