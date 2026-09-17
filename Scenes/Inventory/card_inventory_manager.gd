class_name CardInventoryManager

extends Control


@onready var SlotScene = preload("uid://crlm24wlk5oc0")
@onready var basicCard: CardBase = preload("uid://c5mkw4xmmuod1").instantiate()

var Inventory: Array = []

var columns: int = 10
var rows: int = 4


@export var slotContainer: GridContainer


func _ready()->void:
	basicCard._startup()
	basicCard.visible = false
	initialiseGrid()
	loadCells()
	addToEmpty(basicCard.data)

func initialiseGrid()->void:
	Inventory.resize(columns)
	#print("Added column(x)")
	for column in range(columns):
		Inventory[column] = []
		Inventory[column].resize(rows)
		#print("Added rows (", rows,") in column #", column)

func loadCells()->void:
	slotContainer.columns = columns
	for row in range(rows):
		for column in range(columns):
			var newSlot: InventorySlot = SlotScene.instantiate()
			Inventory[column][row] = newSlot
			slotContainer.add_child(newSlot, true)#force readableName
	print(Inventory)

func checkSlots(data: CardResource, inventoryPos: Vector2i)->int: #false is you cant place card here
	for x in range(inventoryPos.x ,inventoryPos.x + (data.size.x - 1)):
		for y in range(inventoryPos.y ,inventoryPos.y + (data.size.y- 1)):
			if Inventory[x][y].hasCard:
				if Inventory[x][y].tier == data.tier:
					return 2 #can combine
				elif Inventory[x][y].tier != null:
					return 0 #has card
	return 1 #empty


func removeCard(data: CardResource, inventoryPos: Vector2i)->void:
	for x in range(inventoryPos.x ,inventoryPos.x + data.size.x):
		for y in range(inventoryPos.y ,inventoryPos.y + data.size.y):
			if Inventory[x][y] == data:
				Inventory[x][y] = null


func combineCards(data: CardResource, inventoryPos: Vector2i, data2: CardResource)->void:
	pass


func addCard(data: CardResource, inventoryPos: Vector2i)->void:
	#check if the section has card in it already
	
	
	for x in range(inventoryPos.x ,inventoryPos.x + data.size.x):
		for y in range(inventoryPos.y ,inventoryPos.y + data.size.y):
			if Inventory[x][y].hasCard:
				push_error("CardAlreadyInSlot: ", Vector2i(x,y), " | InvPos: ", inventoryPos)
				return
	
	var centerPosArr = []
	
	for x in range(inventoryPos.x ,inventoryPos.x + data.size.x):
		for y in range(inventoryPos.y ,inventoryPos.y + data.size.y):
			Inventory[x][y].contents = data
			centerPosArr.append(Inventory[x][y].getCenter())
	
	
	var newCard: CardBase = data.scene.instantiate()
	newCard._startup(centerPosArr)
	
	add_child(newCard)

func addToEmpty(data: CardResource)->void:
	for x in range(columns):
		for y in range(rows):
			if !Inventory[x][y].hasCard:
				var result = checkSlots(data, Vector2i(x,y))
				if result == 1: #clear slot
					addCard(data, Vector2i(x,y))
					print("Added card at: ", Vector2i(x,y))
					return
	push_error("Inventory full. ")
				
			
