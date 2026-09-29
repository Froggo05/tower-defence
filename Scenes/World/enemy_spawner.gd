extends Node2D

@export var intervalSize: float = 1.0

var spawners: Array = []
var wavePoints:int = 1000
var clock: float = 0.0


signal signalWave(waveSize: int)


func _ready() -> void:
	signalWave.connect(spawnWave)
	
	for child in get_children():
		spawners.append(child)

func _process(delta: float) -> void:
	if Global.waveActive:
		waveIntervals(delta)


func spawnWave(waveSize: int)->void:
	if waveSize > Global.enemysInCurrentDay.size():
		waveSize = Global.enemysInCurrentDay.size()
	for i in range(waveSize):
			spawnEnemy(Global.enemysInCurrentDay.pop_back())

func spawnEnemy(enemyType: String)->void:
	var spawner: Spawner = spawners[randi_range(0, spawners.size())]
	spawner.spawnEnemy(enemyType)

func waveIntervals(delta: float)->void:
	if clock > intervalSize:
		clock -= intervalSize
		signalWave.emit(randi_range(0, 5))
	clock += delta
