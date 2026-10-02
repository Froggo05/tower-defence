class_name GlobalScript extends Node

#enums
enum CardRarity {
	BASIC,
	UNCOMMON,
	RARE,
	LEGENDARY
}

#loaders (places to look for enemys or units if i want to spawn stuff (maybe projectiles too))
var entityList: Dictionary = {"unit": "uid://do5p2oo1evqfk", "enemy": "uid://b27eegnueu6ys", "smallOrc" : "uid://dwb4cdvam3ofp"}
var projectileList: Dictionary = {"projectile": "uid://0ax2j8etcyia"}

#important vars
var metaHealth: = 400 #kingdom health? you observe the core of each wall. zoom in to a wall front/side of the kingdom
var gold: = 0
var food: = 500
var unitCount: int = 0
var enemyCount: int = 0
var projectileCount: int = 0

##references -in place for global use
var nextTarget :Core
var currentHealthBar: healthBar
var worldScene: Node2D
var currentlyAvaliableCards: Array[String] = ["uid://c5mkw4xmmuod1"]
var enemysInCurrentDay: Array = []


#units
var targetList: Array = []

#game state controls
var waveActive: bool = true

#global funcs

static func closeEnough(A, B) -> bool:
	var comparison = A.snappedf(0.05) == B.snappedf(0.05)
	return comparison

func addToAvaliableCards(UID)->void:
	currentlyAvaliableCards.append(UID)
func removeFromAvaliableCards(UID)->void:
	currentlyAvaliableCards.erase(UID)

#G	-summon funcs
func summonUnit(spawnPosition: Vector2)->void:
	Global.unitCount += 1
	var newUnit:Unit = Global.entityList["unit"].instantiate()
	newUnit.global_position = spawnPosition
	newUnit.name = "Unit#" + str(Global.unitCount)
	worldScene.unitContainer.add_child(newUnit)
func summonEnemy(spawnPosition: Vector2, enemyType: String):
	Global.enemyCount += 1
	var newEnemy: Enemy = Global.entityList[enemyType].instantiate()
	newEnemy.global_position = spawnPosition
	newEnemy.name = "Enemy#" + str(Global.enemyCount)
	Global.targetList.append(newEnemy)
	worldScene.enemyContainer.add_child(newEnemy)

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
