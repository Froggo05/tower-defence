class_name MenuResourceContainer extends Control

func _ready()->void:
	for child in get_children():
		if child is InventoryManager:
			MenuManager.avaliableInventories.set(child.IUID, child)
			if child.name == "PlayerInventory":
				MenuManager.playerInventoryIUID = child.IUID
