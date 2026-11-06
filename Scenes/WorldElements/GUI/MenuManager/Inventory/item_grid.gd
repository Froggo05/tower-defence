@tool
class_name InventorySlotGridContainer extends GridContainer

#-----enums-----

#-----sub-components-----
@onready var inventorySlotPacked: PackedScene = preload("uid://bnpc3x54j2idn")
#-----signals-----

#-----variables-----
var InventoryGrid: Array = []
#-----private-----

#-----public-----
func generateGrid(inventorySize: Vector2i, IUID: int)->void:
	self.columns = inventorySize.x 
	InventoryGrid.resize(inventorySize.x)
	
	for x in range(inventorySize.x):
		InventoryGrid[x] = []
		InventoryGrid[x].resize(inventorySize.y)
	
	for y in range(inventorySize.y):
		for x in range(inventorySize.x):
			var slot =  inventorySlotPacked.instantiate() as Slot
			slot.name = str(Vector2i(x,y))
			slot.inventoryCoordinate = Vector2i(x,y)
			slot.label.text = "(" + str(x) + ", " + str(y) + ")"
			slot.updateTexture(slot.inventoryCoordinate, inventorySize)
			slot.IUID = IUID
			if Engine.is_editor_hint():
				pass
			else:
				slot.slotHovered.connect(INVGLOBAL.updateHoveredCell)
			InventoryGrid[x][y] = slot
			add_child(slot)
	#print(InventoryGrid)

#-----signal responses-----
