extends Node

var pool: Dictionary = {"basicProjectile" : []}
@onready var basicProjectileScene = preload("uid://0ax2j8etcyia")

func _ready() -> void:
	initialisePool(2000, "basicProjectile")

func initialisePool(amount: int, objectType: String)->void:
	for i in range(amount):
		var newProjectile: Projectile = basicProjectileScene.instantiate()
		newProjectile.name = str(Global.projectileCount) + "#basicProjectile"
		Global.projectileCount +=1
		newProjectile._reset()
		pool[objectType].append(newProjectile)



func _getObject(objectType: String, damage: float, _direction: Vector2, spawnPosition: Vector2, target: Enemy) -> void:
	if pool[objectType] == []:
		printerr("Pool '%s' is empty. Creating a new one (the size may be too small)" % objectType)
		return
	var newProjectile:Projectile = pool[objectType].pop_back()
	newProjectile.hide()
	_activateObject.call_deferred(newProjectile, damage, _direction, spawnPosition, target)
	

func _activateObject(object: Projectile,damage: float, _direction: Vector2, spawnPosition: Vector2, target: Enemy):
	add_child(object)
	_set_collisions(object, true)
	object._start(damage, target, spawnPosition)
	
func _returnObject(object: Projectile)->void:
	object._reset()
	_set_collisions(object, false)
	_disableObject.call_deferred(object)


func _disableObject(object)->void:
	remove_child.call_deferred(object)
	pool[object.type].append(object)

func _set_collisions(node: Node, disabled: bool) -> void:
	for child in node.get_children():
		if child is CollisionShape2D or child is CollisionShape3D:
			child.set_deferred("disabled", disabled)   # Deferred for safety during physics
		_set_collisions(child, disabled) #recursive goes through children of childs to clear the whole tree
