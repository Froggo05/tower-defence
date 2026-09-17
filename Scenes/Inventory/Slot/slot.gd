class_name InventorySlot extends Button

var hasCard: bool = false
@onready var debugColour: ColorRect = $ColorRect

var contents: CardResource:
	set(newContents):
		if newContents == null:
			hasCard = false
		else:
			hasCard = true
			contents = newContents
			debugColour.visible = true
	get:
		return contents


func getCenter()->Vector2:
	return Vector2((global_position.x + size.x) /2, (global_position.y + size.y) /2) #TODO: FIXPLSTHANK

func checkTile() -> bool:
	return hasCard

func giveCard(cardResource: CardResource)->void:
	hasCard = true
	contents = cardResource

func removeCard()->void:
	hasCard = false
	contents = null
