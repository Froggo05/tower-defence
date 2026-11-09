extends Menu

#-----sub-components-----
@export var inventoryTarget: Control
@export var coreHealthBarTarget: Control
#-----variables-----
var playerInventory: InventoryManager

#-----public------
func activate()->void:
	for child in get_children():
		child.show()
	playerInventory = MenuManager.getPlayerInventory()
	inventoryTarget.custom_minimum_size = playerInventory.custom_minimum_size
	MenuManager.coreHealthBar.custom_minimum_size = Vector2(size.x, coreHealthBarTarget.size.y)
	playerInventory.show()
	_setCoreHealthBarPos()
	process_mode = Node.PROCESS_MODE_INHERIT

func deactivate()->void:
	for child in get_children():
		if child is ColorRect:
			return
		child.hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func update(delta: float)->void:
	_updateInventoryPosition(delta)
	pass

#-----private-----
func _updateInventoryPosition(delta: float)->void: #inventoryTarget.position.y - MenuManager.coreHealthBar.custom_minimum_size.y, its - because of y axis + being downward
	playerInventory.position = lerp(playerInventory.position, Vector2(inventoryTarget.position.x, inventoryTarget.position.y - MenuManager.coreHealthBar.custom_minimum_size.y), delta * MenuManager.inventoryMoveFactor)

func _setCoreHealthBarPos() ->void:
	MenuManager.coreHealthBar.position = coreHealthBarTarget.position
	MenuManager.coreHealthBar.show()

#-----signals------

#menu buttons
func _on_merchant_button_pressed() -> void:
	change_menu.emit("MerchantMenu")
func _on_camp_button_pressed() -> void:
	change_menu.emit("CampMenu")
func _on_forge_button_pressed() -> void:
	change_menu.emit("ForgeMenu")


#----static-----
