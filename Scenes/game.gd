class_name Game extends Control

var LeftclickPressed:bool = false
var RightclickPressed:bool = false

#exports
@export var worldScene: WorldScene
@export var GUI: GUIManager

func updateDay()->void:
	GUI.updateDay()
	worldScene.updateDay()

func _ready() -> void:
	Global.gold = 1000
	Global.game = self
	updateDay()
	#nextDay()

#func nextDay()->void:
	#GUI.menuManager.menuDict["MerchantMenu"].generateSale()

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	#print("L: ",LeftclickPressed, " R: ", RightclickPressed)
	if LeftclickPressed:
		LeftclickPressed = false
		for a in range(1):
			Global.summonEntity(get_global_mouse_position(), "sgoblin")
	if RightclickPressed:
		RightclickPressed = false
		#Global.summonEnemy(get_global_mouse_position(), "smallOrc")

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

func changeObservedCore(newCore)->void:
	Global.currentHealthBar._changeObserved(newCore.health)
