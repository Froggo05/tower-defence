extends Menu

@export var cardInventoryManager: CardInventoryManager
@export var inventoryTarget: Control

func activate()->void:
	show()
	process_mode = Node.PROCESS_MODE_INHERIT
	cardInventoryManager.show()
	cardInventoryManager.targetPosition = inventoryTarget.global_position
	cardInventoryManager.global_position = Vector2(inventoryTarget.global_position.x, inventoryTarget.global_position.y + 700)

func deactivate()->void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	cardInventoryManager.hide()
	cardInventoryManager.targetPosition = Vector2.ZERO


func _on_merchant_button_pressed() -> void:
	change_menu.emit("MerchantMenu")
