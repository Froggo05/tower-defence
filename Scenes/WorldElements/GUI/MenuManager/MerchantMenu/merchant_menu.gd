class_name MerchantMenu extends Menu

@export var slotContainer: HBoxContainer
@export var inventoryTarget: Control

@onready var merchantSlot = preload("uid://bqvyylr4y52pn")
#func addItemToShop(cardType: CardResource)->void:
var MerchantSlots: Array[MerchantSlot] = []

func generateSale()->void:
	var amountOfSlots = randi_range(3,5)
	
	for slot in range(amountOfSlots):
		MerchantSlots.append(merchantSlot.instantiate())
		slotContainer.add_child(MerchantSlots[slot])
		MerchantSlots[slot].ShopButton.setCard(getRandomAvaliableCard())


func getRandomAvaliableCard()->CardBase:
	var randomIndex = randi_range(0, Global.currentlyAvaliableCards.size() - 1)
	var cardScene: Resource = load(Global.currentlyAvaliableCards[randomIndex])
	return cardScene.instantiate()


func activate()->void:
	show()
	process_mode = Node.PROCESS_MODE_INHERIT
	#cardInventoryManager.global_position = Vector2(inventoryTarget.global_position.x, inventoryTarget.y + 800)

func deactivate()->void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	


func _on_back_button_pressed() -> void:
	exit_menu.emit()
