class_name CoreHealthBar extends ProgressBar
@export var barChangeFactor: float = 5.0

func _process(delta: float) -> void:
	if Global.gameActive or DayNightManager.dayCount > 1:
		_healthbarInterp(delta)

func _healthbarInterp(delta)->void:
		value = lerpf(value, Global.core.healthComponent.queryHealth(), delta * barChangeFactor)
