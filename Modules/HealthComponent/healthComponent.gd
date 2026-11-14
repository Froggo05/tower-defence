class_name HealthComponent extends Area2D

@export_category("Objects")
@export var Hitbox: CollisionShape2D
@export var progressBar: ProgressBar
@export var barTexture: Texture2D
@export var animationPlayer: AnimationPlayer
var isDead: bool = false

@export_category("Variables")
@export var HealthBarScale: float = 1.0
@export var MaxHealth: float = 100.0
@export var barChangeFactor: float = 5.0
@export var barVerticlePadding: float = 5.0
var health: float = 0.0:
	set(value):
		health = clampf(value, 0.0, MaxHealth)
		if health <= 0.0:
			died.emit()
			isDead = true
	get():
		return health

#-----Signal-----

signal damaged(healthLost: float)
signal healed(healthGained: float)
signal died()

func _ready() -> void:
	_setup()

func _physics_process(delta: float) -> void:
	if progressBar != null:
		_healthbarInterp(delta)

func _setup()->void:
	health = MaxHealth
	if progressBar != null:
		progressBar.value = health
		var progressSize = Vector2(MaxHealth * HealthBarScale, 10.0)
		progressBar.set_deferred("size", progressSize) #may have issues later, anchors shouldnt matter here because no control node tree but will see ig
		progressBar.set_deferred("position", Vector2(-progressSize.x/2 ,-Hitbox.shape.get_rect().size.y/2 - progressSize.y - barVerticlePadding))

func damage(damageAmt: float)->void:
	health -= damageAmt
	damaged.emit(damageAmt)

func heal(healing: float)->void:
	health += healing
	healed.emit(healing)

func _healthbarInterp(delta)->void:
	if progressBar != null:
		progressBar.value = lerpf(progressBar.value, health, delta * barChangeFactor)

func queryHealth()->float:
	return health
