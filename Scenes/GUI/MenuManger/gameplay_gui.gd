extends Menu

@export var cardInventoryManager: CardInventoryManager

func activate()->void:
	show()
	process_mode = Node.PROCESS_MODE_INHERIT
	cardInventoryManager.show()

func deactivate()->void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	cardInventoryManager.hide()
