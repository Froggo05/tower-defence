extends Unit

func fireProjectile(targetPosition: Vector2)->void:
	
	#var newProj: Projectile = projectileScene.instantiate()
	#
	#newProj.direction = global_position.direction_to(targetPosition)
	#newProj.global_position = global_position
	#newProj.damage = damage
	#newProj.applyImpulse()
	#
	PoolManager._getObject("basicProjectile", damage, global_position.direction_to(targetPosition), global_position)
	
	canAttack = false
