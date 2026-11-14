extends Node

var pool: Dictionary = {"basicProjectile" : []}
var projectileScenes: Dictionary = {"basicProjectile" : "uid://bc0dee1tvmioh"}

func _ready() -> void:
	loadProjectileScenes()
	initialisePool(200, "basicProjectile")


func loadProjectileScenes()->void:
	for child in projectileScenes:
		projectileScenes[child] = load(projectileScenes[child])
		pool[child] = []

func initialisePool(amount: int, projectileType: String)->void:
	for i in range(amount):
		var newProjectile: Projectile = projectileScenes[projectileType].instantiate()
		
		newProjectile.name = str(Global.projectileCount) + "#basicProjectile"
		
		Global.projectileCount += 1
		
		newProjectile.reset()
		pool[projectileType].append(newProjectile)


func _getObject(projectileType: String, direction: Vector2, spawnPosition: Vector2, target: Entity) -> void:
	if pool[projectileType] == []:
		printerr("Pool '%s' is empty. Creating a new one (the size may be too small)" % projectileType)
		return
	var newProjectile: Projectile = pool[projectileType].pop_back()
	_activateObject.call_deferred(newProjectile, direction, spawnPosition, target)
	

func _activateObject(projectile: Projectile, direction: Vector2, spawnPosition: Vector2, target: Entity):
	Global.worldScene.add_child(projectile)
	
	_set_collisions(projectile, false)
	projectile.start(direction, spawnPosition, target)
	
func _returnObject(projectile: Projectile)->void:
	projectile.reset()
	_set_collisions(projectile, true)
	_disableObject.call_deferred(projectile)

func _disableObject(projectile: Projectile)->void:
	Global.worldScene.remove_child.call_deferred(projectile)
	
	pool[projectile.type].append(projectile)

func _set_collisions(node: Node, disabled: bool) -> void: #FUCK THIS METHOD GOD DAMN IT
	for child in node.get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", disabled)   # Deferred for safety during physics
		_set_collisions(child, disabled) #recursive goes through children of childs to clear the whole tree
