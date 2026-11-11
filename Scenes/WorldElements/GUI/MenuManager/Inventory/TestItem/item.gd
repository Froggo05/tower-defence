@tool
class_name Item extends Control

#-----enums-----

#-----sub-components-----
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
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	sprite.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sprite.texture = attributes.texture
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.scale = INVGLOBAL.uiScale/(attributes.texture.get_size() / INVGLOBAL.invCellPixelSize) #calculate the ratio between this image and the inv slot tile size img
	#print(sprite.scale)
	self.custom_minimum_size = sprite.size * sprite.scale
	pass

func _physics_process(delta: float) -> void:
	_updatePosition(delta)

func _updatePosition(_delta)->void:
	global_position = targetPosition
	#makes no sense RAHH

func setTarget(newPosition: Vector2)->void:
	targetPosition = newPosition
	#global_position = newPosition
	#print(newPosition)

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
