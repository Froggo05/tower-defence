@tool
class_name Item extends Control

#-----enums-----

#-----sub-components-----
@export var valueDisplay: Label
#-----signals-----

#-----variables-----
@export var attributes: ItemAttributes
@export var sprite: TextureRect
@export var invSize: Vector2i = Vector2i(1,1)
@export var moveFactor: float = 300.0
var invPosition : Vector2i = -1.0 * Vector2i.ONE
var IUID: int
var targetPosition: Vector2

#-----private-----
func _ready() -> void:
	sprite.scale = INVGLOBAL.uiScale/(sprite.texture.get_size() / INVGLOBAL.invCellPixelSize) #calculate the ratio between this image and the inv slot tile size img
	#print(sprite.scale)
	self.custom_minimum_size = sprite.size * sprite.scale
	pass

func _physics_process(delta: float) -> void:
	_updatePosition(delta)

func _updatePosition(delta)->void:
	#print(targetPosition, " -> ", position)
	position = position.move_toward(targetPosition, delta * moveFactor) # WHY DOES global_position NOT WORK WHYYYY WAS IT DIFFERENT
	#makes no sense RAHH
#-----public-----
func getTags()-> Dictionary:
	var tagDict: Dictionary = {}
	var attributeList = attributes.get_property_list()
	for attribute: Dictionary in attributeList:
		tagDict = {attribute["name"]: attributes.get(attribute["name"])} #its not stupid trust
	return tagDict

func calculateItemPositionInSlots(slotSize: Vector2)->Vector2:
	var avgPos: Vector2 = ((Vector2(invPosition) + Vector2(invPosition) + Vector2(invSize - Vector2i.ONE))/2 * slotSize)
	var CentrePos: Vector2 = MenuManager.getInventoryManager(IUID).position + avgPos
	#invetnory pos (for offset) + avg position of first and last cell for center point
	return CentrePos
#-----signal responses-----
