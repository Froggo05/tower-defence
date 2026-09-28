class_name InventorySlot extends Button


var hasCard: bool = false
var slotPosition: Vector2i


@onready var debugColour: ColorRect = $ColorRect
@export var label: Label

var card: CardBase:
	set(newCard):
		if newCard == null:
			hasCard = false
			card = null
			debugColour.visible = false
		else:
			hasCard = true
			card = newCard
			debugColour.visible = true
	get:
		return card


signal mousePressed(card: CardBase)
signal mouseReleased()
signal mouseHovered(cellPosition: Vector2i)


func getCenterPoint()->Vector2:
	return global_position + (size/2) #TODO: FIXPLSTHANKyou (in vec2)


func removeCardInSlot()->void:
	#print("Removed Card, ", slotPosition)

	card = null


func _on_button_down() -> void:
	if card == null:
		push_warning("Clicked On empty cell: ", slotPosition)
		return
	mousePressed.emit(card.cellPosition, card)


func _on_button_up() -> void:
	if card == null:
		return
	mouseReleased.emit()


func _on_mouse_entered() -> void:
	mouseHovered.emit(slotPosition)

func _on_mouse_exited() -> void:
	mouseHovered.emit(Vector2i(-1,-1))
