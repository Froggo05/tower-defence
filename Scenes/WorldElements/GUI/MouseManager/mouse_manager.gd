class_name MouseManager extends Control

#MouseDragSelector
var isClicked: bool = false
var mouseDragArea: Rect2 = Rect2()
@onready var mouseSelectionArea: NinePatchRect = $MouseSelectionArea
@export var minimiumArea: float
var mouseDragStart: Vector2
var mouseDragSize: Vector2

func _process(_delta: float) -> void:
	selectionAreaUpdate()

func setArea()->void:
	mouseDragSize =  get_global_mouse_position() - mouseDragStart
	mouseDragArea = Rect2(mouseDragStart, mouseDragSize).abs()
	
	mouseSelectionArea.position = mouseDragArea.position
	mouseSelectionArea.size = mouseDragArea.size
	
	if mouseDragArea.get_area() > minimiumArea:
		mouseSelectionArea.visible = true
	else:
		mouseSelectionArea.visible = false

func selectionAreaUpdate()->void:
	if Input.is_action_pressed("Leftclick"):
		if !isClicked:
			mouseDragStart =  get_global_mouse_position()
			isClicked = true
			return
		setArea()
	else:
		isClicked = false
		
	if Input.is_action_just_released("Leftclick"):
		selectObjectsInArea()
		mouseSelectionArea.visible = false

func selectObjectsInArea()->void:
	#mouseDragArea.has_point()
	pass
