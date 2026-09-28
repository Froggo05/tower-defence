class_name UnitStateMachine extends StateMachine

func _ready() -> void:
	_create_state_map()
	_initialise(starting_state)

func _create_state_map() -> void:
	for child: State in get_children():
		child.finished.connect(_change_state)
		state_map[child.name] = child
