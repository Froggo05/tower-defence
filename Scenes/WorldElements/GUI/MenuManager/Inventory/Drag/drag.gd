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

var lastSlotsCheckedArray: Array[Slot] = []

#-----private-----
func _init(targetItem: Item, dragType: String = "") -> void:
	item = targetItem
	initialItemInvPos = item.invPosition
	type = dragType
	initialPosition = item.global_position
	initialIUID = item.IUID
	MenuManager.getInventoryManager(initialIUID).removeItem(initialItemInvPos, item)
	#need to store the item slot relative to the item size clicked

func _visualiseCheck(hoveredInvIUID: int, inventoryPos: Vector2i)->void:
	var check = MenuManager.getInventoryManager(hoveredInvIUID).checkItemDropPosition(inventoryPos, item)
	
	var itemBounds: Vector2i = Vector2i(inventoryPos.x + item.invSize.x, inventoryPos.y + item.invSize.y)
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
		MenuManager.getInventoryManager(INVGLOBAL.hoveredIUID).placeItem(INVGLOBAL.hoveredCellCoordinate, item)
	else:
		MenuManager.getInventoryManager(initialIUID).placeItem(initialItemInvPos, item)
	_resetSlotHighlight()

func update()->void:
	if INVGLOBAL.mouseIsHovering:
		_resetSlotHighlight()
		_visualiseCheck(INVGLOBAL.hoveredIUID, INVGLOBAL.hoveredCellCoordinate)
	else:
		_resetSlotHighlight()

func setItemTargetPos(pos: Vector2)->void:
	item.global_position = pos 

#-----signal responses-----
