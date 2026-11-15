class_name CastleCore extends StaticEntity
@onready var collision_shape_2d: CollisionShape2D = $StaticBody/CollisionShape2D

func _ready() -> void:
	Global.core = self
	healthComponent.progressBar = MenuManager.theCoreHealthBar
	healthComponent.died.connect(_hasDied)

func getClosestPos(entityPos: Vector2)->Vector2:
	var rad = collision_shape_2d.shape.get("radius")
	return global_position + (rad * -(global_position - entityPos).normalized())

func reset()->void:
	healthComponent.reset()

func _hasDied()->void:
	Global.gameOver()
