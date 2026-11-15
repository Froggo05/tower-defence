class_name DayNightManager extends CanvasModulate

@export var hoursPerDayTime: float = 12.0
@export var hoursPerNightTime: float = 12.0

@export var secondsPerHour: float = 10.0
@export var startingHour: float = 6.0

@export var dayColour: Color = Color(1, 1, 1)
@export var nightColour: Color = Color(0.1,0.1,0.2)

@export var transitionSpeed: float = 2.0
@export var timeBar: ProgressBar

static var timeInHours: float = 0.0
static var totalDayLength: float = 0.0
var tween: Tween
static var isDay: bool = true
var tweenActive: bool
@export var timePause:bool = false


var lightList: Array = []
var lightTweens: Array = []

func reset()->void:
	timeInHours = startingHour
	timeBar.value = timeInHours
	if tween != null:
		tween.kill()
	color = dayColour
	isDay = true

func _ready() -> void:
	Global.dayNightCycle = self
	poolLights()
	totalDayLength = hoursPerDayTime + hoursPerNightTime
	timeInHours = fmod(startingHour, totalDayLength) # a % b but with float
	
	timeBar.max_value = totalDayLength

func poolLights()->void:
	for child in get_children():
		if child is PointLight2D:
			lightList.append(child)

func _process(delta: float) -> void:
	if Global.gameActive:
		_updateTime(delta)

func _updateTime(delta: float)->void:
	if timePause:
		return
	#TODO: FIX THISSSS
	if !tweenActive:
		if isDay:
			_tweenToDay()
		else:
			_tweenToNight()
	
	timeInHours += delta / secondsPerHour
	timeInHours = fmod(timeInHours, totalDayLength)
	
	timeBar.value = timeInHours
	if timeInHours < hoursPerDayTime && !isDay:
		isDay = true
		tweenActive = false
	elif timeInHours > hoursPerDayTime && isDay:
		isDay = false
		tweenActive = false

static func getCurrentHour()->int:
	return int(timeInHours)

static func isDaytime()->bool:
	return isDay

func _tweenToNight()->void:
	print("Tweening To Night")
	_resetTween()
	setLightFlicker()
	for light: PointLight2D in lightList:
		tween.parallel().tween_property(light, "color", Color(1.224, 0.34, 0.0, 1.0), transitionSpeed * secondsPerHour)
	tween.parallel().tween_property(self, "color", nightColour, transitionSpeed * secondsPerHour) #scalar is amt of seconds
	tween.tween_callback(setLightFlicker)
	tweenActive = true

func _tweenToDay()->void:
	print("Tweening To Day")
	_resetTween()
	setLightFlicker()
	for light: PointLight2D in lightList:
		tween.parallel().tween_property(light, "color", Color(3.516, 1.047, 0.0, 0.0), transitionSpeed * secondsPerHour)
	tween.parallel().tween_property(self, "color", dayColour, transitionSpeed * secondsPerHour)
	tweenActive = true

func setLightFlicker()->void: # will need optimisation in future cant do O(n^2) for light lookups
	for light: Light2D in lightList:
		var index = lightList.find(light)
		lightTweens.resize(lightList.size())
		lightTweens[index] = create_tween().bind_node(self)
		lightTweens[index].tween_property(light, "energy", 1.0, randf_range(0.0, 1.0))
		lightTweens[index].set_loops()
		lightTweens[index].tween_property(light, "energy", 1.0, 0.2)
		lightTweens[index].tween_property(light, "energy", 1.2, 0.2)
		lightTweens[index].tween_property(light, "energy", 0.4, 0.5)
		lightTweens[index].tween_property(light, "energy", 1.6, 0.4)
		lightTweens[index].tween_property(light, "energy", 0.7, 0.2)

func _resetTween()->void:
	if tween != null:
		tween.kill()
	tween = create_tween().bind_node(self)
	tween.set_ease(Tween.EASE_IN_OUT)

func _on_check_button_toggled(toggled_on: bool) -> void:
	timePause = toggled_on
