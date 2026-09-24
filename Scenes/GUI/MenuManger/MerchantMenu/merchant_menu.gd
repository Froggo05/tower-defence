class_name MerchantMenu extends Menu

@export var slotContainer: HBoxContainer
@export var cardInventoryManager: CardInventoryManager

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
	cardInventoryManager.show()

func deactivate()->void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	cardInventoryManager.hide()
