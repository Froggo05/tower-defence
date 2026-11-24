class_name Projectile extends Area2D
@export var sprite: Sprite2D

@export var damage: float = 1.0
@export var speed: float = 1.0
@export var path: Curve
@export var maxRange: float = 60.0

var target: Node2D
var px: float = 0.0
var py: float = 1.0
var direction: Vector2
var spawnPosition: Vector2
var type: String = "null"

var travel: Vector2 = Vector2.ZERO

var exhausted: bool = false

@export var fadeSpeed: float = 1.0
var isFading = false

func returnSelf()->void:
	print("Returning: ", name)
	PoolManager._returnObject(self)

func start(newDirection: Vector2, newSpawnPosition: Vector2, newTarget: Node2D)->void:
	show()
	rotation = newDirection.angle()
	spawnPosition = newSpawnPosition
	global_position = newSpawnPosition
	direction = newDirection
	target = newTarget
	process_mode = Node.PROCESS_MODE_INHERIT
	px = 0.0
	py = 0.0
	exhausted = false
	travel = Vector2.ZERO
	reset_physics_interpolation()

func reset()->void:
	exhausted = false
	rotation = 0
	spawnPosition = Vector2.ZERO
	global_position = Vector2.ZERO
	target = null
	direction = Vector2.ZERO
	travel = Vector2.ZERO
	_resetFade()
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(delta: float) -> void:
	if exhausted or travel.length() >= maxRange:
		#if target != null && !isFading:
			#target.healthComponent.damage(damage)
		_fadeOut(delta)
		return
	
	if target != null:
		direction = (target.global_position - spawnPosition).normalized()
	#px += delta * speed #percentage of path completed in x
	#px = clamp(px, 0.0, 1.0)
	travel += direction * speed * delta
	self.global_position += direction * speed * delta
	#py = path.sample(px) #scalar of y based on the path percentage completed of x
	#
	#global_position.x = spawnPosition.x + (vectorTo.x * px)
	#global_position.y = spawnPosition.y + (vectorTo.y * (px+py))

func _fadeOut(delta)->void:
	isFading = true
	modulate = lerp(modulate, Color(1.0, 1.0, 1.0, 0.0), delta * fadeSpeed)
	if modulate.is_equal_approx(Color(1.0, 1.0, 1.0, 0.0)):
		returnSelf()

func _resetFade()->void:
	isFading = false
	modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_area_entered(area: Area2D) -> void:
	if area is HealthComponent and !exhausted:
		area.damage(damage)
		exhausted = true
