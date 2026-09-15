extends Node2D

class_name Projectile
var type: String = "basicProjectile"
var velocity: Vector2
var speed: float = 2000.0
var damage: float
var direction: Vector2
var damageTarget: Enemy


@export var Ray: RayCast2D


var lifeTime: float = 3.0
var lifeClock: float = 0.0
var runClock: bool = false


func updateVelocity() -> void:
	velocity = speed * direction


func _process(delta: float) -> void:
	timer(delta)
	updateRay(delta)
	updatePosition(delta)


func updatePosition(delta):
	#print("Pos: ",str(position), " Vel: ",str(velocity), " delta: ",str(delta))
	position += velocity * delta
	updateVelocity()


func updateRay(delta)->void:
	Ray.target_position = velocity * delta # relative value do not add its own position to itself again
	Ray.force_raycast_update()
	attackTarget()


func attackTarget()->void:
	var hit = Ray.get_collider()
	if hit is Hitbox:
		if hit.has_method("_getHit"):
			hit._getHit(damage)
		
		#print("DealingDamage: ", damage, " To: ", damageTarget.name)
		PoolManager._returnObject(self)


func _start(newDamage: float, newDirection: Vector2)->void:
	startClock()
	#newSpeed: float,
	#speed = 2000.0
	damage = newDamage
	direction = newDirection
	rotation = velocity.angle()
	process_mode = Node.PROCESS_MODE_INHERIT
	Global.projectileCount += 1
	show()


func _reset()->void:
	stopClock()
	hide()
	#speed = 0
	damage = 0
	direction = Vector2.ZERO
	position = Vector2.ZERO
	process_mode = Node.PROCESS_MODE_DISABLED
	Global.projectileCount -=1

func startClock(): runClock = true
func stopClock(): runClock = false; resetClock()
func resetClock(): lifeClock = 0.0


func timer(delta)->void:
	if runClock == false:
		return
	if lifeClock >= lifeTime:
		lifeClock -= lifeTime
		PoolManager._returnObject(self)
		return
	
	lifeClock += delta


func _timeout() -> void:
	PoolManager._returnObject(self)
