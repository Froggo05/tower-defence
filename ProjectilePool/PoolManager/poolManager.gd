extends Node

var pool: Dictionary = {"basicProjectile" : []}
@onready var basicProjectileScene = preload("uid://0ax2j8etcyia")

func _ready() -> void:
	initialisePool(2000, "basicProjectile")

func initialisePool(amount: int, objectType: String)->void:
	for i in range(amount):
		var newProjectile: Projectile = basicProjectileScene.instantiate()
		newProjectile.name = str(Global.projectileCount) + "#basicProjectile"
		pool[objectType].append(newProjectile)


func _getObject(objectType: String, damage: float, _direction: Vector2, global_position: Vector2, target: Enemy) -> void:
	if pool[objectType] == []:
		printerr("Pool '%s' is empty. Creating a new one (the size may be too small)" % objectType)
		return

	var newProjectile:Projectile = pool[objectType].pop_back()
	
	_set_collisions(newProjectile, true)
	add_child.call_deferred(newProjectile)
	newProjectile.call_deferred("_start", damage, target, global_position)


func _returnObject(object: Projectile)->void:
	object._reset()
	_set_collisions(object, false)
	pool[object.type].append(object)
	remove_child.call_deferred(object)

func _set_collisions(node: Node, disabled: bool) -> void:
	for child in node.get_children():
		if child is CollisionShape2D or child is CollisionShape3D:
			child.set_deferred("disabled", disabled)   # Deferred for safety during physics
		_set_collisions(child, disabled) #recursive goes through children of childs to clear the whole tree
