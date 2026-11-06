@tool
extends Node
#-----enums-----

#-----sub-components-----

#-----signals-----

#-----variables-----

#-----private-----

#-----public-----
var SelectedItem: Item
var inventoryCount: int
var hoveredCellCoordinate: Vector2i
var hoveredIUID: int
var uiScale: Vector2 = Vector2(8.0,8.0)
var mouseIsHovering: bool = false

const invCellPixelSize: float = 8.0

func getUniqueInventoryIndex()-> int:
	inventoryCount += 1
	return inventoryCount-1



#-----signal responses-----

func updateHoveredCell(inventoryCoordinate: Vector2i, inventoryIndex: int)->void:
	hoveredCellCoordinate = inventoryCoordinate
	hoveredIUID = inventoryIndex
	#print("Updating Hover: ", hoveredCellCoordinate, " in inventory: ", inventoryIndex)
