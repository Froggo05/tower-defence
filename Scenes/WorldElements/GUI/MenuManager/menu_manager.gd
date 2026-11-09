class_name MenuManager extends Control

#-----sub-components-----
@onready var baseItemPacked: PackedScene = preload("uid://c681mrvm6ivda")
@export var menuResourceContainer: MenuResourceContainer
@export var inventory: InventoryManager
@export var defaultMenu: Menu
@export var startMenu: Menu

static var coreHealthBar: CoreHealthBar

#-----variables-----
var menuDict: Dictionary = {}
var dragInstance: Drag
var leftclickActive: bool = false
var rightclickActive: bool = false
static var avaliableInventories: Dictionary[int, InventoryManager] = {}
static var playerInventoryIUID: int
static var activeMenu: Menu
static var inventoryMoveFactor: float = 10.0
#-----private-----
func _ready() -> void:
	_establishScene()
	coreHealthBar = %CoreHealthBar

func _process(delta: float) -> void:
	activeMenu.update(delta)

func _connectSignals()->void: #manages dynamic symbols
	for child in get_children():
		if child is Menu:
			child.exit_menu.connect(_return)
			child.change_menu.connect(_changeMenu)

func _establishScene()->void:
	_collectAllMenus()
	_setMenu(startMenu)
	_connectSignals()

func _collectAllMenus()->void:
	for child in get_children():
		if child is Menu:
			menuDict[child.name] = child

func _setMenu(menu: Menu)->void:
	if activeMenu != null:
		activeMenu.deactivate()
	else:
		#push_warning("Set menu when ActiveMenu is null")
		pass
	
	
	activeMenu = menu
	activeMenu.activate()

func _physics_process(_delta: float) -> void:
	if leftclickActive:
		_updateDrag()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Rightclick"):
		rightclickActive = true
	if event.is_action_released("Rightclick"):
		rightclickActive = false
	if event.is_action_pressed("Leftclick"):
		leftclickActive = true
		_startDrag()
	if event.is_action_released("Leftclick"):
		leftclickActive = false
		_endDrag()

func _updateDrag()->void:
	if dragInstance == null:
		return
	dragInstance.setItemTargetPos(get_global_mouse_position())
	dragInstance.update()

func _startDrag()->void:
	if dragInstance != null:
		#push_warning("Last drag not finished")
		dragInstance = null
	
	var slot = _getInventorySlotHovered()
	if slot == null:
		print("Not clicked on slot | Drag failed")
		return
	
	var item = slot.itemContained
	if item == null:
		#maybe add a minimum mousemovement before drag
		print("No item in hovered slot | Drag failed")
		return
	
	#print("Starting Drag")
	dragInstance = Drag.new(item)

func _getInventorySlotHovered()->Slot:
	if !INVGLOBAL.mouseIsHovering:
		#push_warning("No Inventory Hovered")
		return
	var activeinventory = getInventoryManager(INVGLOBAL.hoveredIUID)
	var inventorySlot = activeinventory.inventoryGrid[INVGLOBAL.hoveredCellCoordinate.x][INVGLOBAL.hoveredCellCoordinate.y] as Slot
	
	return inventorySlot

func _endDrag()->void:
	if dragInstance == null:
		return
	dragInstance.endDrag()

#-----public------

#-----signals------
func _return()->void:
	_setMenu(defaultMenu)

func _changeMenu(menuName: String)->void:
	var menu: Menu = menuDict[menuName]
	_setMenu(menu)

func _on_button_pressed() -> void:
	var item: Item = baseItemPacked.instantiate()
	inventory.addItemToInventory(item)

#----static-----
static func getInventoryManager(iuid: int)->InventoryManager:
	return avaliableInventories[iuid]

static func getSlot(invPosition:Vector2i ,iuid: int)->Slot:
	var inv = getInventoryManager(iuid)
	if invPosition.x > inv.inventorySize.x - 1 or invPosition.y > inv.inventorySize.y - 1:
		#print("Slot outside of bounds")
		return null
	
	var slot = inv.inventoryGrid[invPosition.x][invPosition.y]
	return slot

static func getPlayerInventory()->InventoryManager:
	return getInventoryManager(playerInventoryIUID)

static func requestActiveMenuChange(menu: String)->void:
	activeMenu.menuChangeRequest(menu)
