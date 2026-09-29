class_name Spawner extends NinePatchRect

var spawnArea: Rect2

func _ready()->void:
	spawnArea.position = self.position
	spawnArea.size = self.size


func _randomPoint(area: Rect2) -> Vector2 :
	var startPoint = area.position
	var endPoint = area.position + area.size
	var point: Vector2 = Vector2(randf_range(startPoint.x, endPoint.x), randf_range(startPoint.y, endPoint.y))
	return point

func spawnEnemy(enemyType: String)->void:
	var spawnPoint = _randomPoint(spawnArea)
	Global.summonEnemy(spawnPoint, enemyType)
