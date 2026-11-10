class_name CastleCore extends StaticEntity
@onready var collision_shape_2d: CollisionShape2D = $StaticBody/CollisionShape2D

func _ready() -> void:
	Global.core = self
	healthComponent.progressBar = MenuManager.coreHealthBar

func getClosestPos(entityPos: Vector2)->Vector2:
	var rad = collision_shape_2d.shape.get("radius")
	return global_position + (rad * -(global_position - entityPos).normalized())

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if healthComponent.health <= 0:
		Global.gameOver()
