class_name LightningProjectile extends BasicHitscanProjectile

@export var line2D: Line2D

func _start(newDamage: float, newTarget: Enemy, spawnPosition: Vector2)->void:
	process_mode = Node.PROCESS_MODE_INHERIT
	isActive = true
	damage = newDamage
	line2D.clear_points()
	line2D.add_point(spawnPosition)
	line2D.add_point(newTarget.position)
	Global.projectileCount += 1
func _reset()->void:
	hide()
	line2D.clear_points()
	damage = 0.0
	process_mode = Node.PROCESS_MODE_DISABLED
	Global.projectileCount -= 1
