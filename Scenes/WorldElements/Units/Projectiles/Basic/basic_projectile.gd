extends Projectile
class_name movingProjectile
#flags	
var oneShot: bool = true
var active :bool = false
var needsLoading:bool = false
#important vars
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
@export var fadeRate: float = 5.0

@export var shadowSprite: Sprite2D
@export var sprite: Sprite2D

#sprite manipulation vars
var percentageFromTarget: float = 0.0
var trajectoryRange: Vector2 = Vector2.ZERO
var startPos: Vector2 = Vector2.ZERO
var target: Enemy
var targetGlobalPosition: Vector2
var nextPosition: Vector2
var lastPosition: Vector2
var nextPositionYCorrection: float 

#clock
var lifeTime: float = 3.0
var lifeClock: float = 0.0
var runClock: bool = false


func _start(newDamage: float, newTarget: Enemy, spawnPosition: Vector2)->void:
	process_mode = Node.PROCESS_MODE_INHERIT
	active = false
	startClock()
	damage = newDamage
	target = newTarget

	startPos = spawnPosition
	#updatePosition(0.001)
	#print("projStartPos:", startPos)
	Global.projectileCount += 1
	needsLoading = true
	active = false


func _reset()->void:
	stopClock()
	hide()
	active = false
	#speed = 0
	damage = 0
	position = Vector2.ZERO
	percentageFromTarget = 0.0
	trajectoryRange = Vector2.ZERO
	target = null
	nextPosition = Vector2.ZERO
	process_mode = Node.PROCESS_MODE_DISABLED
	Global.projectileCount -=1


func _physics_process(delta: float) -> void:
	if needsLoading:
		oneShot = true
		needsLoading = false
		global_position = startPos
		reset_physics_interpolation()
		await get_tree().physics_frame
		show() # needed to be called on the next frame? otherwise the streaking was happening due to physics interp which is good still.
		active = true
	
	
	if active:
		timer(delta) 
		updateRotation()
		updatePosition(delta)
	else:
		fadeOut(delta)
	
	if !active and oneShot:
		oneShot = false
		PoolManager._set_collisions(self, true)


func fadeOut(delta)->void:
	modulate.a = move_toward(modulate.a, 0.0, delta)


func updateRotation()->void: # run before update postioin so global position = last position still
	direction = (nextPosition-lastPosition).normalized()
	sprite.rotation = direction.angle()
	#print(sprite.rotation)


func updatePosition(delta):
	if target != null:
		targetGlobalPosition = target.global_position
	calucluateNextPos(delta)
	updateRay()


func calucluateNextPos(delta)->void:
	trajectoryRange = targetGlobalPosition - startPos
	
	if trajectoryRange.normalized().x < trajectoryRange.normalized().y:
		if trajectoryRange.y > 0:
			moveSpeed = -moveSpeed
		updatePositionwithXCurve(delta)
	else:
		updatePositionwithYCurve(delta)


func updatePositionwithXCurve(delta)->void:
	var distanceTo = targetGlobalPosition.y - startPos.y
	var projectileMaxRelativeHeight = abs(distanceTo) * projectileMaxHeight
	
	var nextPositionY = global_position.y + (moveSpeed * delta)
	var nextPositionYNormalised = (nextPositionY - startPos.y)/trajectoryRange.y
	
	var nextXPosNormalised = -movementCurve.sample(nextPositionYNormalised)
	var nextPositionXCorrectionNormalised = axisCorrectionCurve.sample(nextPositionYNormalised)
	var nextPositionXCorrection = nextPositionXCorrectionNormalised * trajectoryRange.x
	var nextXTrajectorPosition = nextXPosNormalised * projectileMaxRelativeHeight
	
	var nextPositionX =  nextXTrajectorPosition + startPos.x + nextPositionXCorrection
	nextPosition = Vector2(nextPositionX, nextPositionY)
	
	updateNextSpeed(nextPositionYNormalised)
	shadowSprite.rotation = sprite.rotation
	updateShadowXCurve(nextPositionXCorrection)
	if snappedf(nextPositionYNormalised, 0.01) >= 1.0:
		active = false
		return    
	lastPosition = global_position  
	global_position = nextPosition


func updatePositionwithYCurve(delta)->void:
	
	
	
	var distanceTo = targetGlobalPosition.x - startPos.x
	var projectileMaxRelativeHeight = abs(distanceTo) * projectileMaxHeight
	var nextPositionX = global_position.x + (moveSpeed * delta)
	var nextPositionXNormalised = (nextPositionX - startPos.x)/trajectoryRange.x
	var nextYPosNormalised = -movementCurve.sample(nextPositionXNormalised)
	var nextPositionYCorrectionNormalised = -axisCorrectionCurve.sample(nextPositionXNormalised)
	nextPositionYCorrection = nextPositionYCorrectionNormalised * trajectoryRange.y
	var nextPositionY = (nextYPosNormalised * projectileMaxRelativeHeight) + startPos.y - nextPositionYCorrection
	nextPosition = Vector2(nextPositionX, nextPositionY)
	
	updateNextSpeed(nextPositionXNormalised)
	shadowSprite.rotation = sprite.rotation
	reset_physics_interpolation()
	updateShadowYCurve(nextPositionYCorrection)
	if snappedf(nextPositionXNormalised, 0.01) >= 1.0:
		active = false
		return    
	lastPosition = global_position  
	global_position = nextPosition


func updateShadowXCurve(next_position_correction: float) -> void:
	shadowSprite.global_position = Vector2(
		startPos.x + next_position_correction,
		nextPosition.y
	)


func updateShadowYCurve(next_position_correction: float) -> void:
	shadowSprite.global_position = Vector2(
		nextPosition.x,
		startPos.y - next_position_correction
	)

func updateNextSpeed(nextPositionXNormalised: float)->void:
	var nextMoveSpeedNormalised = speedCurve.sample(nextPositionXNormalised)
	if trajectoryRange.x < 0:
		nextMoveSpeedNormalised = -nextMoveSpeedNormalised
	moveSpeed = nextMoveSpeedNormalised * maxMoveSpeed


func updateRay()->void:
	Ray.target_position = to_local(nextPosition)
	Ray.force_raycast_update()
	attackTarget()


func attackTarget()->void:
	var hit = Ray.get_collider()
	if hit is EnemyHitbox:
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
