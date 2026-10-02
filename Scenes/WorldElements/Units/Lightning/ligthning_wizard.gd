extends Unit

@export var lightningProjectilePoint: Node2D

func _physics_process(delta: float) -> void:
	super(delta)
	_updateNav()
	selectionModule.trigger()
	

func _updateNav()->void:
	navAgent.target_position = targetPosition
	var nextPos: Vector2 = navAgent.get_next_path_position()
	
	
