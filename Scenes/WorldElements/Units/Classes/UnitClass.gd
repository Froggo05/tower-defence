extends Node2D
class_name Unit

#important vars
var targetList: Array[Enemy] = []
var projectileScene: PackedScene
var direction: Vector2
var currentTarget: Enemy

#exports
@export var aniSprite: AnimatedSprite2D
@export var aniPlayer: AnimationPlayer

@export var damage: float = 1.0
@export var health: float = 1.0

@export var rotationSpeed: float = 0.5
@export var projectilesPerShot: int = 1
@export var projectileSpread: float = 75.0

@export var navAgent: NavigationAgent2D
@export var selectionModule: Node2D
#clock settings

@export var attackSpeed: float = 0.01

var clock: float = 0.0
var canAttack: bool = true
var targetRotation: float

#navigation vars
var targetPosition: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	timer(delta)
	if currentTarget == null:
		updateTarget()
		return
	else:
		pass
		#rotateToTarget(delta)
		
	if canAttack && rotation == targetRotation:
		attack(currentTarget)


func _ready() -> void:
	projectileScene = Global.projectileList["projectile"]


func attack(target: Enemy)->void:
	fireProjectile(target)
	currentTarget = null

func fireProjectile(target: Enemy)->void:
	
	direction = global_position.direction_to(target.global_position)
	
	#projectile spread calc
	if projectilesPerShot > 1:
		var firingDirection = direction
		firingDirection = firingDirection.rotated(deg_to_rad(-(projectileSpread/2)))
		var angleBetween = projectileSpread/(projectilesPerShot-1)
		#print("Angle between " , angleBetween)
		
		for projectileNum in range(projectilesPerShot):
			#print("# ",projectileNum, " Current Angle: ",  angleBetween*projectileNum)
			PoolManager._getObject("basicProjectile", damage, firingDirection.rotated(deg_to_rad(angleBetween*projectileNum)), global_position, target)
	else:
		PoolManager._getObject("basicProjectile", damage, direction, global_position, target)
	canAttack = false
	#print("Unit globalPos: ", global_position)


func reload()->void:
	pass


func updateTarget()->void:
	var tempList:Array[Enemy] = []
	for target in targetList:
		
		if target != null:
			tempList.append(target)
	targetList = tempList
		
	if targetList == []:
		#print("Target list empty for some reason")
		return
	
	targetList.sort_custom(func(a: Enemy, b: Enemy)->bool: return global_position.distance_squared_to(a.global_position) > global_position.distance_squared_to(b.global_position))
	currentTarget = targetList.pop_back()


func rotateToTarget(delta)->void:
	if currentTarget != null:
		direction = (currentTarget.global_position - global_position)
		targetRotation = direction.angle()
		rotation = rotate_toward(rotation, targetRotation, rotationSpeed * delta)

func timer(delta)->void:
	if canAttack:
		return
	
	if clock >= attackSpeed:
		clock -= attackSpeed
		canAttack = true
		return
	
	clock += delta
	

func _on_attack_range_area_entered(area: Area2D) -> void:
	if area.Parent is Enemy:
		targetList.append(area.Parent)
		print(area.Parent)

#updateTarget closest
#super inefficient make a sort that sorts the array by distance to and only updates if add to list or etc.
#distance squared is more optimal than distance to
#var distToCurrent = currentTarget.global_position.distance_to(global_position)
#for target in Global.targetList:
	#var distToNew = target.global_position.distance_to(global_position)
	#if distToNew < distToCurrent:
		#currentTarget = target
		#distToCurrent = distToNew
##print(Global.targetList, " Current target: ", currentTarget.name)
