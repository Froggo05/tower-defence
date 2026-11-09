class_name EnemyManager extends Node2D

@export var intervalSize: float = 1.0

var spawners: Array = []
var wavePoints = 1000
static var wavePointsRemaining: float = 1000
static var waveActive: bool = false
#"name" : [unlockDay, cost]
static var enemyDetailsList: Dictionary[String, Array] = {"sgoblin" : [0, 1]}
static var enemiesAvaliable: Array = []
var dayUpdated: bool = false

func _ready() -> void:
	for child in get_children():
		spawners.append(child)

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if DayNightManager.isDaytime() && !dayUpdated:
		updateDay()
		dayUpdated = true
	if !DayNightManager.isDaytime() && dayUpdated:
		dayUpdated = false
		wavePointsRemaining = wavePoints + wavePointsRemaining
	
	if wavePointsRemaining > 0 && !DayNightManager.isDaytime():
		waveActive = true
	else: 
		waveActive = false
			

func updateDay()->void:
	wavePoints = 1.1 * wavePoints
	for enemy in enemyDetailsList.keys():
		if enemyDetailsList[enemy][0] <= DayNightManager.dayCount:
			enemiesAvaliable.append(enemy)
			#enemiesAvaliable.sort_custom(func (a,b)->bool: return a[1] > b[1])

static func getRandomEnemyForDay()->String:
	return enemiesAvaliable[randi_range(0, enemiesAvaliable.size() - 1)]
