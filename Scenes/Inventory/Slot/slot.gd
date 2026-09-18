class_name InventorySlot extends Button


var hasCard: bool = false
var slotPosition: Vector2i


@onready var debugColour: ColorRect = $ColorRect
@export var label: Label

var stackSize: int = 0
var stackCount: int = 0

var card: CardBase:
	set(newCard):
		if newCard == null:
			hasCard = false
			card = newCard
			stackSize = 0
			stackCount = 0
			debugColour.visible = false
		else:
			hasCard = true
			card = newCard
			stackSize = card.data.stackSize
			stackCount = 1
			debugColour.visible = true
	get:
		return card


signal mousePressed(invPosition: Vector2i, card: CardBase)
signal mouseReleased(invPosition: Vector2i, card: CardBase)
signal mouseHovered(cellPosition: Vector2i)


func getCenterPoint()->Vector2:
	return global_position + (size/2) #TODO: FIXPLSTHANKyou (in vec2)


func removeData()->void:
	print("removedCard, ", card.cellPosition)
	card = null


func _on_button_down() -> void:
	if card == null:
		push_warning("Cell is empty: ", slotPosition)
		return
	mousePressed.emit(card.cellPosition, card)


func _on_button_up() -> void:
	if card == null:
		return
	mouseReleased.emit(card.cellPosition, card)


func _on_mouse_entered() -> void:
	mouseHovered.emit(slotPosition)


func canStack()->bool:
	if stackCount >= stackSize:
		return false
	else:
		return true
