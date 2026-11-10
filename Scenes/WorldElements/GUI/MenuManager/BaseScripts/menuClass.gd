class_name Menu extends Control
#--------Ignores--------
@warning_ignore_start("unused_signal")

# -------Exports--------
@export var MenuMovementFactor: float = 5.0

#--------Vars-----------
var targetPosition: Vector2 = Vector2.ZERO

#--------Signals--------
signal exit_menu()
signal change_menu(menuName: String)


#PublicMethods - used by other nodes
@warning_ignore("unused_parameter")
func update(delta: float)->void:
	pass
func activate()->void:
	show()
	process_mode = Node.PROCESS_MODE_INHERIT
func deactivate()->void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED

@warning_ignore("unused_parameter")
func menuChangeRequest(menu: String)->void:
	change_menu.emit(menu)

#PrivateMethods - only used within this node(class) - shown with an _ prefix
func _ready() -> void:
	deactivate()

func _moveToTarget(delta)->void:
	global_position = lerp(global_position, targetPosition, delta * MenuMovementFactor)

#Signals
