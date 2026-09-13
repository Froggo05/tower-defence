extends CharacterBody2D
class_name Unit




#todo learn object pooling

#important vars
var damage: float = 1.0
var health: float = 100.0
var projectileScene: PackedScene
var direction: Vector2
var currentTarget: Enemy
#clock settings
var attackSpeed: float = 5
var clock: float = 0.0
var canAttack: bool = true


func _physics_process(delta: float) -> void:
	timer(delta)
	if currentTarget == null:
		updateTarget()
		return
	if canAttack:
		attack(currentTarget)


func _ready() -> void:
	projectileScene = Global.projectileList["projectile"]


func attack(target: Enemy)->void:
	look_at(target.global_position)
	fireProjectile(target.global_position)


func fireProjectile(targetPosition: Vector2)->void:
	
	Global.projectileCount += 1
	
	var newProj: Projectile = projectileScene.instantiate()
	
	newProj.direction = global_position.direction_to(targetPosition)
	newProj.global_position = global_position
	newProj.damage = damage
	newProj.applyImpulse()
	
	get_tree().current_scene.add_child.call_deferred(newProj)
	canAttack = false


func reload()->void:
	pass


func updateTarget()->void:
	if Global.targetList == []:
		return
	
	if Global.targetList[-1] == null:
		Global.targetList.remove_at(-1)
		return
	
	currentTarget = Global.targetList[-1]

func timer(delta)->void:
	if canAttack:
		return
	
	if clock >= attackSpeed:
		clock -= attackSpeed
		canAttack = true
		return
	
	clock += delta
	


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
