extends Projectile

func _ready() -> void:
	type = "basicProjectile"

#func _on_area_entered(area: Area2D) -> void:
	#print("HIT!")
	#if area is HealthComponent:
		#area.damage(damage)
		#PoolManager._returnObject(self)
