class_name MerchantMenu extends Menu

@export var merchantList: MerchantList
@export var goldCount: Label

var inventoryZIndex: int
#[0,1] Day =unlock, cost
var itemDetailsList: Dictionary[String, Array] = {"basicArcher" : [0, 1], "basicFighter" : [0, 2], "basicWizard" : [0,3]}
var itemsAvaliable: Array = []

func _physics_process(_delta: float) -> void:
	goldCount.text = "Gold | " + str(Global.gold)

func updateDay()->void:
	_updateAvaliableItems()
	
	var itemsForSale: Array[Item] = generateItemsForCurrentDay()
	merchantList.buildItemList(itemsForSale)

func generateItemsForCurrentDay()->Array[Item]:
	var itemList:Array[Item]
	var amtItemForSale: int = randi_range(4, 10)
	for i in range(amtItemForSale):
		var randIndex = randi_range(0, itemsAvaliable.size()-1)
		var randItemPacked: PackedScene = itemsAvaliable[randIndex]
		var item: Item = randItemPacked.instantiate()
		itemList.append(item)
	return itemList

func _updateAvaliableItems()->void:
	var newItems = []
	for itemName in itemDetailsList.keys():
		if itemDetailsList[itemName][0] <= Global.dayCount:
			var itemPacked = Global.itemList[itemName]
			newItems.append(itemPacked)
			
	itemsAvaliable = newItems

func activate()->void:
	show()
	MenuManager.getPlayerInventory().hide()
	process_mode = Node.PROCESS_MODE_INHERIT

func deactivate()->void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_back_button_pressed() -> void:
	exit_menu.emit()
