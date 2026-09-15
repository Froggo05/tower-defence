extends Unit

func fireProjectile(targetPosition: Vector2)->void:
	
	#var newProj: Projectile = projectileScene.instantiate()
	#
	#newProj.direction = global_position.direction_to(targetPosition)
	#newProj.global_position = global_position
	#newProj.damage = damage
	#newProj.applyImpulse()
	direction = global_position.direction_to(targetPosition)
	if projectilesPerShot > 1:
		var firingDirection = direction
		firingDirection = firingDirection.rotated(deg_to_rad(-(projectileSpread/2)))
		var angleBetween = projectileSpread/(projectilesPerShot-1)
		#print("Angle between " , angleBetween)
		
		for projectileNum in range(projectilesPerShot):
			#print("# ",projectileNum, " Current Angle: ",  angleBetween*projectileNum)
			PoolManager._getObject("basicProjectile", damage, firingDirection.rotated(deg_to_rad(angleBetween*projectileNum)), global_position)
		canAttack = false
	else:
		PoolManager._getObject("basicProjectile", damage, direction, global_position)
