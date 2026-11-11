class_name MerchantList extends ItemList
var itemsArray:Array[Item] = []

func buildItemList(addItemsArray:Array[Item])->void:
	itemsArray = []
	itemsArray.resize(addItemsArray.size())
	for currentItem in addItemsArray:
		var itemIndex = add_item(str(currentItem.attributes.value) + "g", currentItem.attributes.texture, true)
		itemsArray[itemIndex] = currentItem


func _on_complete_deal_pressed() -> void:
	var selectedItemIndexes: Array = get_selected_items()
	var costTotal: int = 0
	for itemIndex: int  in selectedItemIndexes:
		costTotal += itemsArray[itemIndex].attributes.value
	##TODO Must add a condition for if the inventory is full, maybe fail or add to a buffer or something
	if costTotal <= Global.gold:
		Global.gold -= costTotal
		for itemIndex: int  in selectedItemIndexes:
			MenuManager.getPlayerInventory().addItemToInventory(itemsArray[itemIndex])
			
