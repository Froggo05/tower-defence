class_name Projectile extends Area2D
@export var damage: float = 1.0
@export var speed: float = 1.0
@export var path: Curve
var target: Entity
var px: float = 0.0
var py: float = 1.0
var pyMod: float = 0.0
var vectorTo: Vector2
var spawnPosition: Vector2

func start(direction: Vector2, newSpawnPosition: Vector2, newTarget: Entity)->void:
	show()
	rotation = direction.angle()
	spawnPosition = newSpawnPosition
	global_position = newSpawnPosition
	
	target = newTarget
	
	vectorTo = spawnPosition - target.global_position
	process_mode = Node.PROCESS_MODE_INHERIT
	px = 0.0
	py = 0.0
	pyMod = 0.0
	reset_physics_interpolation()

func reset()->void:
	rotation = 0
	spawnPosition = Vector2.ZERO
	global_position = Vector2.ZERO
	target = null
	vectorTo = Vector2.ZERO
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(delta: float) -> void:
	vectorTo = target.global_position - spawnPosition
	
	px += delta * speed #percentage of path completed in x
	px = clamp(px, 0.0, 1.0)
	py = path.sample(px) #scalar of y based on the path percentage completed of x
	#print("px,py ",Vector2(px, py))
	#print("gpos ",global_position)
	#print("spawnPos ", spawnPosition)
	#print("targetPos ", target.global_position)
	#print("v2 ", vectorTo)
	
	pyMod += delta * speed
	pyMod = clamp(pyMod, 0.0, 1.0)
	
	global_position.x = spawnPosition.x + (vectorTo.x * px)
	global_position.y = spawnPosition.y + (vectorTo.y * (pyMod+py))


func _on_area_entered(area: Area2D) -> void:
	print("HIT!")
	if area is HealthComponent:
		area.damage(damage)
		PoolManager._returnObject(self)
