class_name wall extends Node2D

@export var unitSpace: Control

var unitList: Array = [Unit.new()]
@export var maxUnits: int ##not currently in use.

func _processUnitSlots()->Array[Vector2]:
	var unitSlots: Array[Vector2] = []
	maxUnits = unitList.size()#not currently in use.
	for slot in range(unitList.size()):
		print(slot)
		if slot > maxUnits:
			return unitSlots
		
		var slotPosition = Vector2(unitSpace.size.x / slot, unitSpace.size.y)
		unitSlots.append(slotPosition) 
		
	return unitSlots

func _assignUnitPositions()->void:
	var avaliableSlots = _processUnitSlots()
	for unit: Unit in unitList:
		unit.targetPosition = avaliableSlots.pop_back()
