extends Menu

@export var inventoryTarget: Control

func activate()->void:
	show()
	process_mode = Node.PROCESS_MODE_INHERIT

func deactivate()->void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_merchant_button_pressed() -> void:
	change_menu.emit("MerchantMenu")
