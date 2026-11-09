@tool
class_name Slot extends Control

#-----enums-----
enum TextureIndex{
	ERROR = -1,
	BOX,
	TOP_LEFT_CORNER,
	TOP_EDGE,
	TOP_RIGHT_CORNER,
	TOP_CUP,
	LEFT_EDGE,
	BLANK_TILE,
	RIGHT_EDGE,
	VERTICLE_TUBE,
	BOTTOM_LEFT_CORNER,
	BOTTOM_EDGE,
	BOTTOM_RIGHT_CORNER,
	BOTTOM_CUP,
	LEFT_CUP,
	HORIZONTAL_TUBE,
	RIGHT_CUP,
}

#-----sub-components-----
@export_category("Sub-Components")
@export var TextureDict: Dictionary[String,TextureRect]
@export var label: Label
var atlastSize: Vector2i = Vector2i(4,4)
var textureCellSize: Vector2 = Vector2(8.0,8.0)

var sizePixels: Vector2
#-----signals-----
signal slotHovered(inventoryType: Vector2i, IUID: int)

#-----variables-----
@export_category("Variables")
var tween: Tween

var inventoryCoordinate: Vector2i = Vector2i.ZERO
var IUID: int
var itemContained: Item:
	set(value):
		if value == null:
			hasItem = false
		else: 
			hasItem = true
		itemContained = value
var hasItem: bool = false


#-----private-----
func _ready() -> void:
	sizePixels = textureCellSize * INVGLOBAL.uiScale
	
	self.custom_minimum_size = sizePixels
	for child in get_children():
		if child is TextureRect:
			child.size = sizePixels
			TextureDict[child.name] = child
		if child is Label:
			child.size = sizePixels

func _getTextureType(slotPosition: Vector2i, itemSize:Vector2i)->int:#returns a frame index (int)
	var minimum: Vector2i = Vector2i.ZERO
	var maximum: Vector2i = itemSize - Vector2i.ONE
	
	if itemSize == Vector2i.ONE: #if its a 1x1 always has nothing on its sides
		return TextureIndex.BOX
		
	#Check the edgecase where you need the tube type inventory slots
	if maximum.x == 0:
		if slotPosition.y == minimum.y:
			return TextureIndex.TOP_CUP
		if slotPosition.y == maximum.y:
			return TextureIndex.BOTTOM_CUP
		return TextureIndex.VERTICLE_TUBE
	if maximum.y == 0:
		if slotPosition.x == minimum.x:
			return TextureIndex.LEFT_CUP
		if slotPosition.x == maximum.x:
			return TextureIndex.RIGHT_CUP
		return TextureIndex.HORIZONTAL_TUBE
		
	#Check the edgecase where you only need simple corners and edges
	if slotPosition == minimum:
		return TextureIndex.TOP_LEFT_CORNER
	
	if slotPosition.x == maximum.x and  slotPosition.y == maximum.y:
		return TextureIndex.BOTTOM_RIGHT_CORNER
	
	if slotPosition.x == minimum.x and slotPosition.y == maximum.y:
		return TextureIndex.BOTTOM_LEFT_CORNER
	
	if slotPosition.x == maximum.x and slotPosition.y == minimum.y:
		return TextureIndex.TOP_RIGHT_CORNER
	
	if slotPosition.x == minimum.x:
		return TextureIndex.LEFT_EDGE
	
	if slotPosition.x == maximum.x:
		return TextureIndex.RIGHT_EDGE
	
	if slotPosition.y == minimum.y:
		return TextureIndex.TOP_EDGE
	
	if slotPosition.y == maximum.y:
		return TextureIndex.BOTTOM_EDGE
	#If not one of the edge cases then use what would be a central tile.
	return TextureIndex.BLANK_TILE

func _resetTween()->void:
	if tween != null:
		tween.kill()
	tween = create_tween().bind_node(self)
	tween.set_ease(Tween.EASE_IN_OUT)

#-----public-----
func updateTexture(slotPosition: Vector2i, itemSize:Vector2i)->void:
	var textureIndex: int = _getTextureType(slotPosition, itemSize)
	setSprite(textureIndex)

func setSprite(index: TextureIndex)->void:
	for texture in TextureDict.keys():
		TextureDict[texture].texture.region = getTextureAtlasRegion(index)

func getTextureAtlasRegion(index: int)->Rect2:
	#push_warning("SlotTextureIndex:", index)

	var PositionX: float = index % atlastSize.y
	@warning_ignore("integer_division")
	var PositionY: float = round(index / atlastSize.y) #round for safety
	
	var cellPositionX = PositionX * textureCellSize.x
	var cellPositionY = PositionY * textureCellSize.y
	
	#push_warning("Inventory Coordintate: ",self.inventoryCoordinate, " | Texture Index: ",TextureIndex.find_key(index), " | Cell Coords: (", PositionX ,",", PositionY,")" )
	
	var cellRegion = Rect2(cellPositionX, cellPositionY, textureCellSize.x, textureCellSize.y) #multiply by individual sprite size to get the actual region
	
	return cellRegion

func setItem(item: Item)->void:
	itemContained = item

func removeItem()->void:
	itemContained = null

func visualiseCheck(slotCheck: int)->void: 
	match slotCheck:
		InventoryManager.SLOTCHECK.NULL:
			modulate = Color(1.0, 0.0, 0.0, 1.0)
		InventoryManager.SLOTCHECK.EMPTY:
			modulate = Color(0.0, 9.419, 0.0)
		InventoryManager.SLOTCHECK.FULL:
			modulate = Color(9.419, 0.0, 0.0, 1.0)
		InventoryManager.SLOTCHECK.SAME:
			modulate = Color(9.419, 9.419, 0.0, 1.0)
		InventoryManager.SLOTCHECK.BLANK:
			modulate = Color(1.0, 1.0, 1.0, 1.0)

#-----signal responses-----
func on_mouse_entered() -> void:
	slotHovered.emit(inventoryCoordinate, IUID)
	animateHover()

func on_mouse_exited() -> void:
	animateHoverDisolve()

func animateHover()->void:
	_resetTween()
	tween.parallel().tween_property(TextureDict["DefaultTexture"], "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.001)
	
func animateHoverDisolve()->void:
	_resetTween()
	tween.parallel().tween_property(TextureDict["DefaultTexture"], "modulate", Color(1.0, 1.0, 1.0, 1.0), 1)
