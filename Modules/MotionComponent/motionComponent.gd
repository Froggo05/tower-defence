class_name MotionComponent extends Node2D
#----enums-----
enum TARGETMOVEMENT{
	STATIC = 0,
	DYNAMIC = 1
}

#-----sub-components-----
@export var navAgent: NavigationAgent2D
@export var parent: Node2D
@export var motionAnimationTree: AnimationTree
#-----signals-----

#-----variables-----

	#Motion
@export var speed: float = 0.5
@export var rotationSpeed: float = 1.0
@export var frictionConst: float = 5.0
var targetDirection: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

	#NavAgent
var targetPosition: Vector2:
	set(value):
		assert(navAgent != null, "Accessing Without NavAgent Set")
		navAgent.target_position = value
	get():
		return navAgent.target_position

var nextNavPoint: Vector2 = Vector2.ZERO
var atTarget: bool = false
var targetMovement: int = TARGETMOVEMENT.STATIC
var animationBlend: Vector2 = Vector2.ZERO

#-----private-----
func _setVelocity()->void:
	velocity = targetDirection * speed

func _navUpdate()->void:
	nextNavPoint = navAgent.get_next_path_position()
	targetDirection = parent.global_position.direction_to(nextNavPoint)

func _positionUpdate(delta: float)->void:
	_rotateToTarget(delta)
	_updateVelocity(delta)
	parent.global_position += velocity * delta

func _rotateToTarget(delta: float)->void:
	parent.global_rotation = deg_to_rad(rotate_toward(parent.global_rotation, deg_to_rad(targetDirection.angle()), delta * rotationSpeed))

func _updateVelocity(delta)->void:
	velocity = velocity.move_toward(Vector2.ZERO, delta * frictionConst)

func _updateAnimations()->void:
	motionAnimationTree.set("parameters/MotionSpace/blend_position", animationBlend)
	#print(motionAnimationTree.get("parameters/MotionSpace/blend_position"))

func _physics_process(delta: float) -> void:
	if atTarget:
		if animationBlend == Vector2.ZERO:
			return
		animationBlend = animationBlend.lerp(Vector2.ZERO, delta * 10.0)
		_updateAnimations()
		return
	
	animationBlend = animationBlend.lerp(targetDirection, delta * 10.0)
	_updateAnimations()
	_navUpdate() #first # potential optimisation. Instead of happening every physics process, update it as it gets closer to the target (if the target moves, if it doesnt only do it once)
	_positionUpdate(delta) #second always

#-----public-----
func setTarget(point: Vector2)->void: ##GlobalPosition
	atTarget = false
	targetPosition = point
	navAgent.target_position = targetPosition
	
	_navUpdate()
	_setVelocity()
	_updateAnimations()

#-----signal responses-----
func _on_navigation_finished() -> void:
	print("Target Reached")
	atTarget = true

func _on_nav_waypoint_reached(details: Dictionary) -> void:
	_navUpdate()


func _on_nav_agent_path_changed() -> void:
	_navUpdate()
	_setVelocity()
