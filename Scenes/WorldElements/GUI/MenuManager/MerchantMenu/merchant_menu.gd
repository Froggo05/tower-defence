class_name MerchantMenu extends Menu

@export var merchantList: MerchantList

var inventoryZIndex: int

static var itemDetailsList: Dictionary[String, Array] = {"BasicArcherItem" : [0, 1]}
static var itemsAvaliable: Array = []

func updateDay()->void:
	_updateAvaliableItems()
	
	var itemsForSale = generateItemsForCurrentDay()
	merchantList.buildItemList(itemsForSale)

func generateItemsForCurrentDay()->Array[Item]:
	var itemList:Array
	var amtItemForSale: int = randi_range(4, 10)
	for i in range(amtItemForSale):
		itemList.append(itemsAvaliable[randi_range(0, itemsAvaliable.size())])
	return itemList

func _updateAvaliableItems()->void:
	for item in itemDetailsList.keys():
		if itemDetailsList[item][0] <= Global.dayCount:
			itemsAvaliable.append(item)

func activate()->void:
	show()
	MenuManager.getPlayerInventory().hide()
	process_mode = Node.PROCESS_MODE_INHERIT

func deactivate()->void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_back_button_pressed() -> void:
	exit_menu.emit()
