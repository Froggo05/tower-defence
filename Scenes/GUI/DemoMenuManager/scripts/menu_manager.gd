class_name MenuManager extends Control

#-----Exports-----
@export var defaultMenu: Menu
@export var startMenu: Menu

#-----Vars-----
var activeMenu: Menu
var menuDict: Dictionary = {}

#-----PublicMethods------


#-----PrivateMethods-----
func _ready() -> void:
	_establishScene()

#add extra signals here if you want to use them
func _connectSignals()->void:
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


#-----Signals------
func _return()->void:
	_setMenu(defaultMenu)


func _changeMenu(menuName: String)->void:
	var menu: Menu = menuDict[menuName]
	_setMenu(menu)
