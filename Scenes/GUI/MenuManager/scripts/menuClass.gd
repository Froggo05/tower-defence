class_name Menu extends Control

# -------Exports--------
@export var MenuMovementFactor: float = 5.0

#--------Vars-----------
var targetPosition: Vector2 = Vector2.ZERO

#--------Signals--------
signal exit_menu()
signal change_menu(menuName: String)


#PublicMethods - used by other nodes
func activate()->void:
	show()
	process_mode = Node.PROCESS_MODE_INHERIT
func deactivate()->void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED

#PrivateMethods - only used within this node(class) - shown with an _ prefix
func _ready() -> void:
	deactivate()

func _moveToTarget(delta)->void:
	global_position = lerp(global_position, targetPosition, delta * MenuMovementFactor)

#Signals
