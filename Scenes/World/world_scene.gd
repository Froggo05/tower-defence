extends Node2D

@export var unitContainer: Node2D
@export var enemyContainer: Node2D

func _ready() -> void:
	Global.worldScene = self
