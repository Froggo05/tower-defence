class_name StaticEntity extends Entity

@export var healthComponent: HealthComponent


func _ready() -> void:
	healthComponent.died.connect(_hasDied)

func reset()->void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	show()

func _hasDied()->void:
	hide()
	self.process_mode = Node.PROCESS_MODE_DISABLED
	
