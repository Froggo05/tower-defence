class_name orcBase extends Enemy

func _physics_process(delta: float) -> void:
	_navUpdate()
	super(delta)

func _navUpdate()->void: #dont need to do this comparison as the nav agent handles it. gotta change it but im too tired rn.
	direction = global_position.direction_to(navAgent.get_next_path_position())
