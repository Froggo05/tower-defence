extends TextureProgressBar
class_name healthBar
@export var minProgressColour : Color = Color(0.0, 1.0, 0.0)
@export var maxProgressColour : Color = Color(1.0, 0.0, 0.0, 1.0)
@export var interpSpeed: float = 5.0 

var maxHealthPoints: float = 200.0
var currentHealth: float

func _ready() -> void:
	max_value = maxHealthPoints
	interpColours()


func _process(delta: float) -> void:
	
	if currentHealth == self.value:
		return
	self.value = lerp(self.value, currentHealth, delta * interpSpeed)
	interpColours()


func interpColours()->void:
	var healthPercent = self.value/maxHealthPoints
	self.tint_progress = lerp(maxProgressColour, minProgressColour, healthPercent)


func _updateHealth(health:float)->void:
	currentHealth = health
	currentHealth = clamp(currentHealth, 0, maxHealthPoints)

func _changeObserved(health:float)->void:
	currentHealth = health
