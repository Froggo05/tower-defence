class_name CardBase
extends Node2D

@export var data: CardResource
@export var healthLabel: Label
@export var damageLabel: Label
@export var valueLabel: Label
@export var moveFactor: float = 5.0

var targetPosition

func _startup(centerPos: Array = [Vector2.ZERO]) -> void:
	var posTotal:Vector2 = Vector2.ZERO
	for pos in centerPos:
		posTotal += pos
	posTotal /= centerPos.size()
	position.x = posTotal.x
	position.y = -100
	targetPosition = posTotal

func _ready() -> void:
	damageLabel.text = str(data.stats["Damage"])
	healthLabel.text = str(data.stats["Health"])
	valueLabel.text = str(data.stats["Value"])

func _process(delta: float) -> void:
	if position == targetPosition:
		return
	if targetPosition == null:
		return
	position.move_toward(targetPosition, delta * moveFactor)
