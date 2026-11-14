class_name ArcherUnit extends StaticEntity

var target: Entity

@export var attackSpeed: float = 1.0
var clock: float = 0.0
var inDrag: bool = false

func setTarget(newTarget: Entity)->void:
	target = newTarget

func shootAtTarget()->void:
	print("shooting")
	rotation = (target.global_position - global_position).angle()
	PoolManager._getObject("basicProjectile", global_position.direction_to(target.global_position), global_position, target)

func _physics_process(delta: float) -> void:
	if !attackTimer(delta):
		return
	if target != null:
		shootAtTarget()

func attackTimer(delta)->bool:
	if inDrag:
		return false
	clock += delta
	if clock >= attackSpeed:
		clock -= attackSpeed
		return true
	return false
