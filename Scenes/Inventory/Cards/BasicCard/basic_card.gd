class_name CardBase
extends Node2D

@export var data: CardResource
@export var healthLabel: Label
@export var damageLabel: Label
@export var valueLabel: Label
@export var moveFactor: float = 5.0
var cellPosition: Vector2i #Represents where the top left cell is stored
var targetPosition: Vector2
var pickedUp: bool = false

func _startup(centerPos: Array = [Vector2.ZERO], invPos: Vector2i = Vector2i.ZERO) -> void:
	var posTotal:Vector2 = Vector2.ZERO
	for pos in centerPos:
		posTotal += pos
	posTotal = posTotal/centerPos.size()
	print(posTotal)
	global_position.x = posTotal.x
	global_position.y = -100.0
	print(global_position)
	targetPosition = posTotal
	data.invPos = invPos

func _ready() -> void:
	damageLabel.text = str(data.stats["Damage"])
	healthLabel.text = str(data.stats["Health"])
	valueLabel.text = str(data.stats["Value"])

func _process(delta: float) -> void:
	if !pickedUp && global_position != targetPosition:
		global_position = global_position.lerp(targetPosition, delta * moveFactor)
	
