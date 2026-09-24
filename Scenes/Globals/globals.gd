extends Node

#enums
enum CardRarity {
	BASIC,
	UNCOMMON,
	RARE,
	LEGENDARY
}

#loaders (places to look for enemys or units if i want to spawn stuff (maybe projectiles too))
var entityList: Dictionary = {"unit": "uid://do5p2oo1evqfk", "enemy": "uid://b27eegnueu6ys"}
var projectileList: Dictionary = {"projectile": "uid://0ax2j8etcyia"}
#important vars
var metaHealth: = 400 #kingdom health? you observe the core of each wall. zoom in to a wall front/side of the kingdom
var gold: = 0
var food: = 500
var unitCount: int = 0
var enemyCount: int = 0
var projectileCount: int = 0
#references
var nextTarget :Core
var currentHealthBar: healthBar
var currentlyAvaliableCards: Array[String] = ["uid://c5mkw4xmmuod1"]

#units
var targetList: Array = []

func addToAvaliableCards(UID)->void:
	currentlyAvaliableCards.append(UID)

func removeFromAvaliableCards(UID)->void:
	currentlyAvaliableCards.erase(UID)

func _ready() -> void:
	_loadProjectiles()
	_loadEntities()


func _loadProjectiles()->void:
	for projectile in projectileList:
		projectileList[projectile]  = load(projectileList[projectile])

func _loadEntities()->void:
	for entity in entityList:
		entityList[entity]  = load(entityList[entity])
