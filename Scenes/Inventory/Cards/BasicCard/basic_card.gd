class_name CardBase
extends Node2D

@export var data: CardResource
@export var healthLabel: Label
@export var damageLabel: Label
@export var valueLabel: Label

@export var minMoveFactor: float = 2.0
@export var maxMoveFactor: float = 20.0


var cellPosition: Vector2i #Represents where the top left cell is stored
var targetPosition: Vector2
var pickedUp: bool = false

var moveFactor: float = 5.0

func _startup(centerPos: Array = [Vector2.ZERO], invPos: Vector2i = Vector2i.ZERO) -> void:
	var posTotal:Vector2 = Vector2.ZERO
	for pos in centerPos:
		posTotal += pos
	posTotal = posTotal/centerPos.size()
	#print(posTotal)
	global_position.x = posTotal.x
	global_position.y = -100.0
	#print(global_position)
	targetPosition = posTotal
	
	data.invPos = invPos
	cellPosition = invPos


func moveCard(centerPos: Array = [Vector2.ZERO], invPos: Vector2i = Vector2i.ZERO) -> void:
	var posTotal:Vector2 = Vector2.ZERO
	
	for pos in centerPos:
		posTotal += pos
	posTotal = posTotal/centerPos.size()
	#print(posTotal)

	targetPosition = posTotal
	
	data.invPos = invPos
	cellPosition = invPos

func _ready() -> void:
	damageLabel.text = str(data.stats["Damage"])
	healthLabel.text = str(data.stats["Health"])
	valueLabel.text = str(data.stats["Value"])


func moveTowardTarget(delta: float)->void:
	updateMoveFactor(delta)
	global_position = global_position.lerp(targetPosition, delta * moveFactor)


func updateMoveFactor(delta)->void:
	moveFactor = move_toward(minMoveFactor, maxMoveFactor, global_position.distance_squared_to(targetPosition))

func _process(delta: float) -> void:
	if !pickedUp && global_position != targetPosition:
		moveTowardTarget(delta)
	
