class_name MerchantMenu extends Menu

@export var itemList: ItemList
@export var inventoryTarget: Control

@onready var merchantSlot = preload("uid://bqvyylr4y52pn")
#func addItemToShop(cardType: CardResource)->void:
var MerchantSlots: Array[MerchantSlot] = []
var playerInventory: InventoryManager
var inventoryZIndex: int

#func generateItemSale()->void:
	#var amountOfSlots = randi_range(3,5)
	#
	#for slot in range(amountOfSlots):
		#MerchantSlots.append(merchantSlot.instantiate())
		#slotContainer.add_child(MerchantSlots[slot])
		#MerchantSlots[slot].ShopButton.setCard(getRandomAvaliableCard())

#
#func getRandomAvaliableItems()->CardBase:
	#var randomIndex = randi_range(0, Global.currentlyAvaliableCards.size() - 1)
	#var cardScene: Resource = load(Global.currentlyAvaliableCards[randomIndex])
	#return cardScene.instantiate()

func update(delta: float)->void:
	_updateInventoryPosition(delta)

func _updateInventoryPosition(delta: float)->void:
	playerInventory.global_position = lerp(playerInventory.global_position, inventoryTarget.global_position, delta * MenuManager.inventoryMoveFactor)

func activate()->void:
	playerInventory = MenuManager.getPlayerInventory()
	inventoryZIndex = playerInventory.z_index
	playerInventory.z_index = self.z_index + 1
	inventoryTarget.custom_minimum_size = playerInventory.custom_minimum_size
	playerInventory.show()
	show()
	process_mode = Node.PROCESS_MODE_INHERIT
	#cardInventoryManager.global_position = Vector2(inventoryTarget.global_position.x, inventoryTarget.y + 800)

func deactivate()->void:
	if playerInventory != null:
		playerInventory.z_index = inventoryZIndex
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_back_button_pressed() -> void:
	exit_menu.emit()
