class_name HealthComponent extends Area2D

@export_category("Objects")
@export var Hitbox: CollisionShape2D
@export var progressBar: ProgressBar
@export var barTexture: Texture2D
@export var animationPlayer: AnimationPlayer

@export_category("Variables")
@export var HealthBarScale: float = 1.0
@export var MaxHealth: float = 100.0:
	set(value):
		MaxHealth = value
		progressBar.size.x = MaxHealth
	get():
		return MaxHealth
@export var barChangeFactor: float = 5.0
@export var barVerticlePadding: float = 5.0
var health: float = 0.0:
	set(value):
		health = clampf(value, 0.0, MaxHealth)
		if health <= 0.0:
			died.emit()
	get():
		return health

#-----Signal-----

signal damaged(healthLost: float)
signal healed(healthGained: float)
signal died()

func _ready() -> void:
	_setup()

func _physics_process(delta: float) -> void:
	_healthbarInterp(delta)

func _setup()->void:
	health = MaxHealth
	progressBar.value = health
	progressBar.size.x = MaxHealth * HealthBarScale
	
	progressBar.position.y = -Hitbox.shape.get_rect().size.y/2 - progressBar.size.y - barVerticlePadding
	progressBar.position.x = -progressBar.size.x/2

func _damage(damage: float)->void:
	health -= damage
	damaged.emit(damage)

func _heal(healing: float)->void:
	health += healing
	healed.emit(healing)

func _healthbarInterp(delta)->void:
	progressBar.value = lerpf(progressBar.value, health, delta * barChangeFactor)
