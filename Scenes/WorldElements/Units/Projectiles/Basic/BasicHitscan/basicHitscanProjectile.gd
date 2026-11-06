class_name BasicHitscanProjectile extends Projectile 

var startPos: Vector2 = Vector2.ZERO
var endPos: Vector2 = Vector2.ZERO
var damage: float = 1.0

@export var lifetime:float = 0.0
var lifeClock: float = 0.0

var isActive: bool = false
var isLoaded: bool = false

@warning_ignore("unused_parameter")
func _start(newDamage: float, newTarget: Enemy, spawnPosition: Vector2)->void:
	pass

func _reset()->void:
	pass

func lifeTimer(delta)->void:
	if isActive == false:
		return
	if lifeClock >= lifetime:
		lifeClock -= lifetime
		PoolManager._returnObject(self)
		return
	
	lifeClock += delta

func _physics_process(delta: float) -> void:
	lifeTimer(delta)
