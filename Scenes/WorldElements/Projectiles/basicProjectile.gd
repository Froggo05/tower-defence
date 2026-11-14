class_name Projectile extends Area2D
@export var sprite: Sprite2D

@export var damage: float = 1.0
@export var speed: float = 1.0
@export var path: Curve
var target: Entity
var px: float = 0.0
var py: float = 1.0
var pyMod: float = 0.0
var vectorTo: Vector2
var spawnPosition: Vector2
var type: String = "null"

@export var fadeSpeed: float = 1.0
var isFading = false

func returnSelf()->void:
	print("Returning: ", name)
	PoolManager._returnObject(self)

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
	_resetFade()
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(delta: float) -> void:
	if px == 1.0:
		if target != null && !isFading:
			target.healthComponent.damage(damage)
		_fadeOut(delta)
		return
	
	
	if target != null:
		vectorTo = target.global_position - spawnPosition
	px += delta * speed #percentage of path completed in x
	px = clamp(px, 0.0, 1.0)
	py = path.sample(px) #scalar of y based on the path percentage completed of x
	
	global_position.x = spawnPosition.x + (vectorTo.x * px)
	global_position.y = spawnPosition.y + (vectorTo.y * (px+py))

func _fadeOut(delta)->void:
	isFading = true
	modulate = lerp(modulate, Color(1.0, 1.0, 1.0, 0.0), delta * fadeSpeed)
	if modulate.is_equal_approx(Color(1.0, 1.0, 1.0, 0.0)):
		returnSelf()

func _resetFade()->void:
	isFading = false
	modulate = Color(1.0, 1.0, 1.0, 1.0)
