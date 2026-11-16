class_name MerchantList extends ItemList
var itemsList:Dictionary = {}

func buildItemList(addItemsArray:Array)->void:
	for currentItem in addItemsArray:
		var itemIndex: int = add_item(str(currentItem.attributes.value) + "g", currentItem.attributes.texture, true)
		itemsList.set(itemIndex, currentItem)


func _on_complete_deal_pressed() -> void:
	var selectedItemIndexes: Array = get_selected_items()
	var selectedItems = []
	var costTotal: int = 0
	print(selectedItemIndexes)
	for itemIndex in selectedItemIndexes:
		var item: Item = itemsList[itemIndex]
		selectedItems.append(item)
		costTotal += item.attributes.value
	##TODO Must add a condition for if the inventory is full, maybe fail or add to a buffer or something
	if costTotal <= Global.gold:
		Global.gold -= costTotal
		for item in selectedItems:
			MenuManager.getPlayerInventory().addItemToInventory(item)
		for itemIndex in selectedItemIndexes:
			self.set_item_disabled(itemIndex, true)
		self.deselect_all()
	pass
