extends Area2D
class_name Hitbox

@onready var Parent: Node2D = $".."
signal GotHit()

func _getHit(damage: float)->void:
	Parent._takeDamage(damage)
