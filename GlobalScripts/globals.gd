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
var itemList: Dictionary = {"basicWizard" : "uid://pv4rxr5mgvrp", "basicFighter" : "uid://nlnbvl6s0w86", "basicArcher" : "uid://iximqptbajwr"}
var projectileList: Dictionary = {}

#important vars
var metaHealth: = 400 #kingdom health? you observe the core of each wall. zoom in to a wall front/side of the kingdom
var gold: = 0
var food: = 500
var entityCount: int = 0
var entityCap: int = 500
var projectileCount: int = 0

var enemiesKilled: int = 0
var gameActive = false

var dayCount:int = 0

##references -in place for global use
var worldScene: WorldScene
var core: CastleCore
var game: Game
var enemyManager: EnemyManager
#units
var targetList: Array = []

#global funcs

func updateDay()->void:
	dayCount += 1
	print("updatingDay")
	game.updateDay()


func gameOver()->void:
	gameActive = false
	MenuManager.requestActiveMenuChange("GameOverMenu")

func restart()->void:
	gameActive = false
	enemyManager.reset()
	MenuManager.requestActiveMenuChange("StartMenu")
	pass

#G	-summon funcs

func summonEntity(spawnPosition: Vector2, enemyType: String)-> Entity:
	print("Attempting Summon at: ", spawnPosition)
	if entityCount < entityCap:
		Global.entityCount += 1
		var newEntity: Entity = Global.entityList[enemyType].instantiate()
		newEntity.name = "Entity#" + str(Global.entityCount)
		Global.targetList.append(newEntity)
		worldScene.entityManager.add_child(newEntity)
		newEntity.global_position = spawnPosition
		return newEntity
	return null

#privateFuncs
func _ready() -> void:
	_loadProjectiles()
	_loadEntities()
	_loadItems()

func _loadProjectiles()->void:
	for projectile in projectileList:
		projectileList[projectile]  = load(projectileList[projectile])
func _loadEntities()->void:
	for entity in entityList:
		entityList[entity]  = load(entityList[entity])
func _loadItems()->void:
	for item in itemList:
		itemList[item]  = load(itemList[item])
