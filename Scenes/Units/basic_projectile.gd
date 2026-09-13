extends Node2D

class_name Projectile

var velocity: Vector2
var speed: float = 2000.0
var damage: float
var direction: Vector2
var damageTarget: Enemy
@export var Ray: RayCast2D
var offset:Vector2 = Vector2(-10.0,10.0)

func applyImpulse() -> void:
	velocity = direction * speed

func _process(delta: float) -> void:
	updateRay(velocity, delta)
	updatePosition(delta)


func _physics_process(delta: float) -> void:
	pass


func updatePosition(delta):
	position += velocity * delta


func updateRay(velocity: Vector2, delta)->void:
	Ray.target_position = velocity*delta # relative value do not add its own position to itself again
	Ray.force_raycast_update()
	attackTarget()


func attackTarget()->void:
	if Ray.get_collider() != null:
		damageTarget = Ray.get_collider().get_parent()
		damageTarget._takeDamage(damage)
		#print("DealingDamage: ", damage, " To: ", damageTarget.name)
		queue_free()






func _timeout() -> void:
	Global.projectileCount -= 1
	queue_free()
