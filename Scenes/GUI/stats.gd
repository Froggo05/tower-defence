extends Label

func _physics_process(_delta: float) -> void:
	text = "Projectile Count: " + str(Global.projectileCount) + " Unit Count: " + str(Global.unitCount) + " Enemy Count: " + str(Global.enemyCount) + " AmtObjectsInPool: " + str(PoolManager.pool["basicProjectile"].size())
