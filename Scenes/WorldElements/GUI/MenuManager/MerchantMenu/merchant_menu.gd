class_name MerchantMenu extends Menu

@export var merchantList: MerchantList

var inventoryZIndex: int

var itemDetailsList: Dictionary[String, Array] = {"basicArcher" : [0, 1]}
var itemsAvaliable: Array = []

func updateDay()->void:
	_updateAvaliableItems()
	
	var itemsForSale: Array = generateItemsForCurrentDay()
	merchantList.buildItemList(itemsForSale)

func generateItemsForCurrentDay()->Array:
	var itemList:Array
	var amtItemForSale: int = randi_range(4, 10)
	for i in range(amtItemForSale):
		itemList.append(itemsAvaliable[randi_range(0, itemsAvaliable.size() - 1)].instantiate())
	return itemList

func _updateAvaliableItems()->void:
	for itemName in itemDetailsList.keys():
		if itemDetailsList[itemName][0] <= Global.dayCount:
			var itemPacked = Global.itemList[itemName]
			itemsAvaliable.append(itemPacked)

func activate()->void:
	show()
	MenuManager.getPlayerInventory().hide()
	process_mode = Node.PROCESS_MODE_INHERIT

func deactivate()->void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_back_button_pressed() -> void:
	exit_menu.emit()
