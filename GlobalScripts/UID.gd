class_name UID extends Node
#Place where all unique IDs are created
static var inventoryCount: int = 0

static func GENERATEINVENTORYINDEX()->int:
	inventoryCount += 1
	var nextIUID = hash(rand_from_seed(inventoryCount))
	return nextIUID
