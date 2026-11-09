extends Label

func _physics_process(_delta: float) -> void:
	text = "Entity Count: " + str(Global.entityCount) + " AmtObjectsInPool: " + str(PoolManager.pool["basicProjectile"].size())
