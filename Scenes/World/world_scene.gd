extends Node2D

@export var unitContainer: Node2D
@export var enemyContainer: Node2D
@export var core: Core

func _ready() -> void:
	Global.worldScene = self
