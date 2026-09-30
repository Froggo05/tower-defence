extends Area2D
class_name EnemyHitbox

@onready var Parent: Node2D = $".."

func _getHit(damage: float)->void:
	Parent._takeDamage(damage)

func getPushed(Impulse: Vector2)->void:
	Parent.velocity += Impulse
