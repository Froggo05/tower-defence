class_name GlobalScript extends Node

#enums
enum CardRarity {
	BASIC,
	UNCOMMON,
	RARE,
	LEGENDARY
}

#loaders (places to look for enemys or units if i want to spawn stuff (maybe projectiles too))
var entityList: Dictionary = {"rock" : "uid://dpa2vcpj3su4b", "sgoblin" : "uid://butihti083ds6"}
var projectileList: Dictionary = {}

#important vars
var metaHealth: = 400 #kingdom health? you observe the core of each wall. zoom in to a wall front/side of the kingdom
var gold: = 0
var food: = 500
var entityCount: int = 0
var entityCap: int = 500
var projectileCount: int = 0
var gameActive = false

##references -in place for global use
var currentHealthBar: healthBar
var worldScene: Node2D
var enemysInCurrentDay: Array = []

var core: CastleCore

#units
var targetList: Array = []

#global funcs

static func closeEnough(A, B) -> bool:
	var comparison = A.snappedf(0.05) == B.snappedf(0.05)
	return comparison

#G	-summon funcs

func summonEntity(spawnPosition: Vector2, enemyType: String)-> Entity:
	print("Attempting Summon at: ", spawnPosition)
	if entityCount < entityCap:
		Global.entityCount += 1
		var newEntity: Entity = Global.entityList[enemyType].instantiate()
		newEntity.name = "Entity#" + str(Global.entityCount)
		Global.targetList.append(newEntity)
		worldScene.entityContainer.add_child(newEntity)
		newEntity.global_position = spawnPosition
		return newEntity
	return null

#privateFuncs
func _ready() -> void:
	_loadProjectiles()
	_loadEntities()
func _loadProjectiles()->void:
	for projectile in projectileList:
		projectileList[projectile]  = load(projectileList[projectile])
func _loadEntities()->void:
	for entity in entityList:
		entityList[entity]  = load(entityList[entity])
