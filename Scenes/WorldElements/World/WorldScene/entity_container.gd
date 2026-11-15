class_name EntityContainer extends Node2D

func reset()->void:
	for child in get_children():
		if child is Entity:
			child.queue_free()
		if child is Projectile:
			PoolManager._returnObject(child)
