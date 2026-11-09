class_name MotionComponent extends Node2D
#----enums-----
enum TARGETMOVEMENT{
	STATIC = 0,
	DYNAMIC = 1
}

#-----sub-components-----
@export var navAgent: NavigationAgent2D
@export var parent: Entity
@export var motionAnimationTree: AnimationTree

#debug
@export var velocityLine: Line2D 
@export var currentTargetPosition: Line2D
#-----signals-----

#-----variables-----

	#Motion
@export var speed: float = 100.0
@export var rotationSpeed: float = 1.0
@export var frictionConst: float = 5.0
var targetDirection: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

var nextNavPoint: Vector2 = Vector2.ZERO
var atTarget: bool = false
var targetMovement: int = TARGETMOVEMENT.STATIC
var animationBlend: Vector2 = Vector2.ZERO

#-----private-----
func _setVelocity()->void:
	velocity = targetDirection * speed

func _rotateToTarget(_delta: float)->void:
	parent.global_rotation_degrees = targetDirection.angle()#rotate_toward(parent.global_rotation, deg_to_rad(), delta * rotationSpeed)

@warning_ignore("unused_parameter")
func _updateVelocity(delta)->void:
	if atTarget:
		velocity = Vector2.ZERO
		
	velocity = velocity.lerp(Vector2.ZERO, delta * frictionConst)
	velocityLine.set_point_position(1, velocity)

func _updateAnimations()->void:
	motionAnimationTree.set("parameters/MotionSpace/blend_position", animationBlend)
	#print(motionAnimationTree.get("parameters/MotionSpace/blend_position"))

func _physics_process(delta: float) -> void:
	animationBlend = animationBlend.lerp(velocity, delta * 10.0)
	if motionAnimationTree != null:
		motionAnimationTree.set("parameters/MotionSpace/blend_position", animationBlend)
	
	nextNavPoint = navAgent.get_next_path_position()
	targetDirection = parent.global_position.direction_to(nextNavPoint)
	
	if atTarget:
		velocity = Vector2.ZERO
	velocity = targetDirection * speed
	velocityLine.set_point_position(1, velocity)
	currentTargetPosition.set_point_position(1, to_local(navAgent.target_position))
	
	parent.rotation = targetDirection.angle()
	parent.global_position += velocity * delta

#-----public-----
func setTarget(point: Vector2)->void: ##GlobalPosition
	atTarget = false
	navAgent.target_position = point
	nextNavPoint = navAgent.get_next_path_position()
	_setVelocity()
	#_updateAnimations()

#-----signal responses-----
func _on_navigation_finished() -> void:
	#print("Target Reached")
	atTarget = true
