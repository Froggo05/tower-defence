class_name Spawner extends NinePatchRect

var spawnArea: Rect2
var spawning: bool = false

var spawnInverval: float = 0.0
var clock: float = 0.0

func _ready()->void:
	spawnArea.position = self.position
	spawnArea.size = self.size


func _randomPoint(area: Rect2) -> Vector2 :
	var startPoint = area.position
	var endPoint = area.position + area.size
	var point: Vector2 = Vector2(randf_range(startPoint.x, endPoint.x), randf_range(startPoint.y, endPoint.y))
	return point

func startSpawning()->void:
	spawning = true
func stopSpawning()->void:
	spawning = false

func _physics_process(delta: float) -> void:
	if Global.enemyManager.waveActive:
		spawnTimer(delta)

func spawnEnemy(enemyType: String)->void:
	Global.enemyManager.wavePointsRemaining -= Global.enemyManager.enemyDetailsList[enemyType][1]
	var spawnPoint = _randomPoint(spawnArea)
	var newEntity: DynamicEntity = Global.summonEntity(spawnPoint, enemyType)
	newEntity.motionComponent.setTarget(Global.core.getClosestPos(spawnPoint))
	newEntity.state = newEntity.STATE.RUN

func spawnTimer(delta: float)->void:
	clock += delta
	if clock >= spawnInverval:
		clock -= spawnInverval
		spawnInverval = randf_range(0.5, 2.0)
		var randEnemy = Global.enemyManager.getRandomEnemyForDay()
		if Global.entityCount + 1 < Global.entityCap:
			spawnEnemy(randEnemy)
