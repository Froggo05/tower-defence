class_name CardResource
extends Resource

@export var stats: Dictionary = {"Damage" : 1.0, "Health" : 100.0, "Value" : 1}
@export var size: Vector2i = Vector2i(1, 2)
@export var tier: int = 0
@export var invPos: Vector2i = Vector2i.ZERO
@export var stackSize: int = 10

static var scene: PackedScene

func _init() -> void:
	if scene == null:
		scene = load("uid://c5mkw4xmmuod1")
