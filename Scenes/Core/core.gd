extends Node2D
class_name Core

var health: float = 100.0
var maxHealth: float = 100.0

func _takeDamage(damage: float)->void:
	health -= damage
	Global.currentHealthBar._updateHealth(health)
