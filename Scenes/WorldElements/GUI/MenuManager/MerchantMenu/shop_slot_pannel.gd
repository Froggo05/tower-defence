class_name MerchantButton extends Button

var hasCard: bool = false
var slotID

@export var label: Label
@export var card_target: Control

var card: CardBase:
	set(newCard):
		if newCard == null:
			hasCard = false
			card = null
		else:
			hasCard = true
			card = newCard
	get:
		return card

var cardIsSold: bool = false

signal mousePressed(card: CardBase)
signal cardPurchased()

func setCard(newCard: CardBase)->void:
	#print("Set card: ", newCard.name)
	card = newCard
	add_child(card)
	#print(card)
	card.global_position = card_target.global_position
	card.targetPosition =  card_target.global_position
	#print(global_position, " ", card.global_position)


func _process(_delta: float) -> void:
	if cardIsSold:
		return
	card.targetPosition =  card_target.global_position


func getCenterPoint()->Vector2:
	return global_position + (size/2)


func removeCard()->void:
	card = null


func _on_button_down() -> void:
	if card == null:
		push_warning("Clicked on emtpy merchant slot")
		return


func _on_button_up() -> void:
	if card == null:
		return
	mousePressed.emit(card)
	cardPurchased.emit()
