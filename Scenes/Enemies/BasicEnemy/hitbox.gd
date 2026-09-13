extends Area2D
class_name Hitbox

@onready var ParentEnemy: Enemy = $".."

func _getHit(damage: float)->void:
	ParentEnemy._takeDamage(damage)
