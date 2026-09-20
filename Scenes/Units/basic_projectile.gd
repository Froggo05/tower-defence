extends Node2D

class_name Projectile
var type: String = "basicProjectile"
var velocity: Vector2
var moveSpeed: float = 1000.0
var maxMoveSpeed: float = 1000.0
var damage: float
var direction: Vector2


@export var Ray: RayCast2D
@export var movementCurve: Curve
@export var projectileMaxHeight: float
@export var axisCorrectionCurve: Curve
@export var speedCurve: Curve

var percentageFromTarget: float = 0.0
var trajectoryRange: Vector2 = Vector2.ZERO
var startPos: Vector2 = Vector2.ZERO
var target: Enemy
var targetGlobalPosition: Vector2
#clock
var lifeTime: float = 3.0
var lifeClock: float = 0.0
var runClock: bool = false


func _start(newDamage: float, newTarget: Enemy, globalPos: Vector2)->void:
	startClock()
	#newSpeed: float,
	#speed = 2000.0
	damage = newDamage
	target = newTarget
	global_position = globalPos
	startPos = global_position
	#print("projStartPos:", startPos)
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
	percentageFromTarget = 0.0
	trajectoryRange = Vector2.ZERO
	target = null
	process_mode = Node.PROCESS_MODE_DISABLED
	Global.projectileCount -=1


func _process(delta: float) -> void:
	timer(delta) 
	updatePosition(delta)


func calucluateNextPos(delta)->Vector2:
	trajectoryRange = targetGlobalPosition - startPos
	var distanceTo = targetGlobalPosition.x - startPos.x
	var projectileMaxRelativeHeight = abs(distanceTo) * projectileMaxHeight
	var nextPositionX = global_position.x + (moveSpeed * delta)
	var nextPositionXNormalised = (nextPositionX - startPos.x)/trajectoryRange.x
	var nextYPosNormalised = -movementCurve.sample(nextPositionXNormalised)
	var nextPositionYCorrectionNormalised = -axisCorrectionCurve.sample(nextPositionXNormalised)
	var nextPositionYCorrectionAbsolute = nextPositionYCorrectionNormalised * trajectoryRange.y
	var nextPositionY = (nextYPosNormalised * projectileMaxRelativeHeight) + startPos.y - nextPositionYCorrectionAbsolute
	var nextPostion = Vector2(nextPositionX, nextPositionY)
	
	calucluateNextSpeed(nextPositionXNormalised)
	
	if snappedf(nextPositionXNormalised, 0.01) == 1.0:
		#fadeOut()
		return global_position
	
	return nextPostion

func calucluateNextSpeed(nextPositionXNormalised: float)->void:
	var nextMoveSpeedNormalised = speedCurve.sample(nextPositionXNormalised)
	moveSpeed = nextMoveSpeedNormalised * maxMoveSpeed

func updatePosition(delta):
	if target != null:
		targetGlobalPosition = target.global_position
	
	global_position = calucluateNextPos(delta)
	updateRay(delta)


func updateRay(delta)->void:
	Ray.target_position = to_local(calucluateNextPos(delta))
	Ray.force_raycast_update()
	attackTarget()


func attackTarget()->void:
	var hit = Ray.get_collider()
	if hit is Hitbox:
		if hit.has_method("_getHit"):
			hit._getHit(damage)
		
		PoolManager._returnObject(self)



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
