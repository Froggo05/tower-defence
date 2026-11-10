class_name Drag extends Node
#-----enums-----
#enum dragType{}
#-----sub-components-----

#-----signals-----

#-----variables-----
var item: Item
var type: String #Drag type, might add later
var initialPosition: Vector2
var offset: Vector2
var dragSmoothing: float = 25.0
var targetinitialPos: Vector2
var uiRef: MenuManager
var initialItemInvPos: Vector2i
var initialIUID: int
var initialClickOffset: Vector2

var lastSlotsCheckedArray: Array[Slot] = []

#-----private-----
func _init(targetItem: Item, clickPosition: Vector2, dragType: String = "") -> void:
	item = targetItem
	initialItemInvPos = item.invPosition
	type = dragType
	initialPosition = item.global_position
	initialClickOffset = clickPosition - initialPosition
	initialIUID = item.IUID
	MenuManager.getInventoryManager(initialIUID).removeItem(initialItemInvPos, item)
	#need to store the item slot relative to the item size clicked

func _visualiseCheck(hoveredInvIUID: int, inventoryPos: Vector2i)->void:
	var check = MenuManager.getInventoryManager(hoveredInvIUID).checkItemDropPosition(inventoryPos, item)
	
	var itemBounds: Vector2i = Vector2i(inventoryPos.x + item.invSize.x, inventoryPos.y + item.invSize.y)
	
	if inventoryPos.x < 0 or inventoryPos.y < 0:
		return
	
	var yrange = range(inventoryPos.y, itemBounds.y)
	var xrange = range(inventoryPos.x, itemBounds.x)
	
	
	for y in yrange:
		for x in xrange:
			var slot = MenuManager.getSlot(Vector2i(x,y), INVGLOBAL.hoveredIUID) as Slot
			if slot == null:
				#push_error("trying to look outside of inv bounds")
				return
			lastSlotsCheckedArray.append(slot)
			slot.visualiseCheck(check)
			slot.animateHover()

func _resetSlotHighlight()->void:
	for slot in lastSlotsCheckedArray:
		slot.visualiseCheck(InventoryManager.SLOTCHECK.BLANK)
		slot.animateHoverDisolve()
		lastSlotsCheckedArray = []

#-----public-----
func endDrag()->void:
	if INVGLOBAL.mouseIsHovering:
		@warning_ignore("narrowing_conversion")
		MenuManager.getInventoryManager(INVGLOBAL.hoveredIUID).placeItem(getHoveredCellPlusInventoryOffset(), item)
	else:
		item.queue_free()
		#MenuManager.getInventoryManager(initialIUID).placeItem(initialItemInvPos, item) #return it to its original pos
	_resetSlotHighlight()

func update()->void:
	if INVGLOBAL.mouseIsHovering:
		_resetSlotHighlight()
		@warning_ignore("narrowing_conversion")
		_visualiseCheck(INVGLOBAL.hoveredIUID, getHoveredCellPlusInventoryOffset())
	else:
		_resetSlotHighlight()

func getHoveredCellPlusInventoryOffset()-> Vector2i:
	
	var offsetCoords = Vector2i(round(initialClickOffset.x /Slot.sizePixels.x), round(initialClickOffset.y /Slot.sizePixels.y))
	#var itemBounds = item.invPosition + item.invSize
	#if !(offsetCoords.x <= itemBounds.x) or !(offsetCoords.x >= item.invPosition.x):
		#offsetCoords.x = item.invPosition.x
	#if !(offsetCoords.y <= itemBounds.y) or !(offsetCoords.y >= item.invPosition.y):
		#offsetCoords.y = item.invPosition.y
	var hoveredCoords = INVGLOBAL.hoveredCellCoordinate
	if item.invSize > Vector2i.ONE:
		hoveredCoords -=  offsetCoords
	return hoveredCoords
func setItemTargetPos(pos: Vector2)->void:
	item.global_position = pos 

#-----signal responses-----
