class_name ArcherUnit extends StaticEntity

var target: Entity

func setTarget(newTarget: Entity)->void:
	target = newTarget

func shootAtTarget()->void:
	print("shooting")
	PoolManager._getObject("basicProjectile", global_position.direction_to(target.global_position), global_position, target)

func _physics_process(_delta: float) -> void:
	if target != null:
		shootAtTarget()
