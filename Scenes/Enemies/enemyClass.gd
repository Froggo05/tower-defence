extends CharacterBody2D
class_name Enemy

var health = 1.0
var damage = 1.0
var isTargeted: bool = false
var direction: Vector2 = Vector2(1.0, 0)

var clock: float = 0.0
var moveInterval: float = 1.0
var canMove: bool = true
var impulse: float = 500.0
var frictionConstant: float = 5.0
var movementToggle: bool = true

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
	if !movementToggle:
		return
	
	timer(delta)
	updatePosition(delta)
	
	if move_and_collide(velocity * delta):
		velocity = Vector2.ZERO
		canMove = false
		movementToggle = false


func attack(target: Area2D)-> void:
	target._takeDamage(damage)


func _takeDamage(incomingDamage: float)-> void:
	health -= incomingDamage
	Global.projectileCount -= 1


func updatePosition(delta)->void:
	#position += velocity * delta
	
	applyFriction(delta)
	applyImpulse(delta)


func applyImpulse(_delta)->void:
	if canMove:
		velocity = impulse * direction
		canMove = false


func applyFriction(delta)->void:
	velocity = lerp(velocity, Vector2.ZERO, frictionConstant * delta)


func _target()->void:
	isTargeted = true


func _attack_range_entered(_area: Area2D) -> void:
	#attack the hitbox in range
	#if area is Hitbox:
		#attack(area)
		pass
