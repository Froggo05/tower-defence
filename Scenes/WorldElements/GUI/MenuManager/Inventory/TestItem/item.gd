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
var ITEMUID: int
var targetPosition: Vector2

var entered: bool = false
var bodyQueue: Array = []



#-----private-----
func _ready() -> void:
	self.z_index = 1000
	ITEMUID = UID.GENERATEUINIQUEIDENTIFIER()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	sprite.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sprite.texture = attributes.texture
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.scale = INVGLOBAL.uiScale/(attributes.texture.get_size() / INVGLOBAL.invCellPixelSize) #calculate the ratio between this image and the inv slot tile size img
	#print(sprite.scale)
	self.custom_minimum_size = sprite.size * sprite.scale
	pass

#func _physics_process(delta: float) -> void:
	#_updatePosition(delta)

func _updatePosition(_delta)->void:
	global_position = targetPosition
	#makes no sense RAHH
	pass

func setTarget(newPosition: Vector2)->void:
	global_position = newPosition
	#global_position = newPosition
	#print(newPosition)

func play()->void:
	#wall.addUnit(attributes.unitSummon)
	MenuManager.getInventoryManager(IUID).removeItem(invPosition, self)
	print("playing ", self, " at ", global_position)
	queue_free()

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
func _on_area_2d_body_entered(body: Node2D) -> void:
	
	var entity = body.get_parent()
	if !entered:
		entered = true
		print(entity)
		INVGLOBAL.wallHovered = entity
	else:
		bodyQueue.push_back(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	var entity = body.get_parent()
	if INVGLOBAL.wallHovered == entity:
		if bodyQueue == []:
			entered = false
			INVGLOBAL.wallHovered = null
			return
			
		INVGLOBAL.wallHovered = bodyQueue.pop_front().get_parent()
		return
	
	bodyQueue.erase(body)
