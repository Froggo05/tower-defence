class_name DayNightManager extends CanvasModulate

@export var hoursPerDayTime: float = 12.0
@export var hoursPerNightTime: float = 12.0

@export var secondsPerHour: float = 10.0
@export var startingHour: float = 6.0

@export var dayColour: Color = Color(1, 1, 1)
@export var nightColour: Color = Color(0.1,0.1,0.2)

@export var transitionSpeed: float = 2.0

static var timeInHours: float = 0.0
static var totalDayLength: float = 0.0
var tween: Tween
static var isDay: bool = true
var tweenActive: bool
@export var timePause:bool = false
var lightList: Array = []

func _ready() -> void:
	poolLights()
	totalDayLength = hoursPerDayTime + hoursPerNightTime
	timeInHours = fmod(startingHour, totalDayLength) # a % b but with float

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
	
	if timeInHours < hoursPerDayTime:
		isDay = true
		tweenActive = false
	else:
		isDay = false
		tweenActive = false

static func getCurrentHour()->int:
	return int(timeInHours)

static func isDaytime()->bool:
	return isDay

func _tweenToNight()->void:
	_resetTween()
	for light: PointLight2D in lightList:
		tween.parallel().tween_property(light, "color", Color(1.224, 0.34, 0.0, 1.0), transitionSpeed * secondsPerHour)
	tween.parallel().tween_property(self, "color", nightColour, transitionSpeed * secondsPerHour) #scalar is amt of seconds
	tweenActive = true

func _tweenToDay()->void:
	_resetTween()
	for light: PointLight2D in lightList:
		tween.parallel().tween_property(light, "color", Color(3.516, 1.047, 0.0, 0.0), transitionSpeed * secondsPerHour)
	tween.parallel().tween_property(self, "color", dayColour, transitionSpeed * secondsPerHour)
	
	tweenActive = true


func _resetTween()->void:
	if tween != null:
		tween.kill()
	tween = create_tween().bind_node(self)
	tween.set_ease(Tween.EASE_IN_OUT)


func _on_check_button_toggled(toggled_on: bool) -> void:
	timePause = toggled_on
