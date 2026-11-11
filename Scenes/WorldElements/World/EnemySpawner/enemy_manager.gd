class_name EnemyManager extends Node2D

@export var intervalSize: float = 1.0

var spawners: Array = []
var wavePoints = 1000
var wavePointsRemaining: float = 1000
var waveActive: bool = false
#"name" : [unlockDay, cost]
var enemyDetailsList: Dictionary[String, Array] = {"sgoblin" : [0, 1]}
var enemiesAvaliable: Array = []
var dayUpdated: bool = false

func _ready() -> void:
	Global.enemyManager = self
	for child in get_children():
		spawners.append(child)

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if wavePointsRemaining > 0 && !DayNightManager.isDaytime():
		waveActive = true
	else: 
		waveActive = false
			

func updateDay()->void:
	wavePoints = 1.1 * wavePoints
	wavePointsRemaining = wavePoints + wavePointsRemaining
	for enemy in enemyDetailsList.keys():
		if enemyDetailsList[enemy][0] <= Global.dayCount:
			enemiesAvaliable.append(enemy)
			#enemiesAvaliable.sort_custom(func (a,b)->bool: return a[1] > b[1])

func reset()->void:
	pass

func getRandomEnemyForDay()->String: #CRASHING HERE FOR SOME REASON
	print(enemiesAvaliable)
	return enemiesAvaliable[randi_range(0, enemiesAvaliable.size() - 1)]
