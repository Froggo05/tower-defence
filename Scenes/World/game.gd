extends Control

var LeftclickPressed:bool = false
var RightclickPressed:bool = false

#exports
@export var currentCore: Core
@export var worldScene: Node2D

#onreadys
@onready var guiHealthBar: Control = %GUIHealthBar

func _ready() -> void:
	Global.currentHealthBar = guiHealthBar
	Global.nextTarget = currentCore
	Global.currentHealthBar._updateHealth(200.0)


func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	#print("L: ",LeftclickPressed, " R: ", RightclickPressed)
	if LeftclickPressed:
		LeftclickPressed = false
		spawnUnit(get_global_mouse_position())
	if RightclickPressed:
		RightclickPressed = false
		spawnEnemy(get_global_mouse_position())

func _unhandled_input(event: InputEvent) -> void:
	mouseInput(event)


func mouseInput(event: InputEvent)->void:
	if event.is_action_pressed("Leftclick"):
		LeftclickPressed = true
	if event.is_action_released("Leftclick"):
		LeftclickPressed = false
	if event.is_action_pressed("Rightclick"):
		RightclickPressed = true
	if event.is_action_released("Rightclick"):
		RightclickPressed = false


func spawnUnit(spawnPosition: Vector2)->void:
	Global.unitCount += 1
	var newUnit:Unit = Global.entityList["unit"].instantiate()
	newUnit.global_position = spawnPosition
	newUnit.name = "Unit#" + str(Global.unitCount)
	worldScene.add_child(newUnit)

func spawnEnemy(spawnPosition: Vector2):
	Global.enemyCount += 1
	var newEnemy: Enemy = Global.entityList["enemy"].instantiate()
	newEnemy.global_position = spawnPosition
	newEnemy.name = "Enemy#" + str(Global.enemyCount)
	Global.targetList.append(newEnemy)
	worldScene.add_child(newEnemy)

func changeObservedCore(newCore)->void:
	currentCore = newCore
	Global.currentHealthBar._changeObserved(newCore.health)
