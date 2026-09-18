class_name CardInventoryManager

extends Control


@onready var SlotScene = preload("uid://crlm24wlk5oc0")
@onready var basicCard: CardBase = preload("uid://c5mkw4xmmuod1").instantiate()

var Inventory: Array = []

var columns: int = 10
var rows: int = 4

var pickupSlot: CardBase:
	set(value):
		value.pickedUp = true
		pickupSlot = value
	get():
		return pickupSlot

var currentCell: Vector2i

@export var slotContainer: GridContainer

@export var cardDragFactor: float = 5.0

func _process(delta: float) -> void:
	if pickupSlot != null:
		pickupSlot.global_position = lerp(pickupSlot.global_position, get_global_mouse_position(), delta * cardDragFactor)


func _ready()->void:
	basicCard._startup()
	basicCard.visible = false
	initialiseGrid()
	loadCells()


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
			newSlot.mousePressed.connect(_on_cell_pressed)
			newSlot.mouseHovered.connect(_on_cell_hovered)
			newSlot.slotPosition = Vector2i(column, row)
			newSlot.label.text = newSlot.name
			print(newSlot.global_position)
	print(Inventory)


func checkSlots(card: CardBase, inventoryPos: Vector2i)->int:
	var data = card.data
	if (inventoryPos + card.data.size) > Vector2i(columns, rows):
		push_error("Inventory Check Failed | outside of bounds | InvPos: ", card.data.size + inventoryPos)
		return -1 #out of bounds
	
	for y in range(card.cellPosition.y ,card.cellPosition.y + (card.data.size.y - 1)):
		for x in range(card.cellPosition.x ,card.cellPosition.x + (card.data.size.x - 1)):
			if Inventory[x][y].hasCard:
				if Inventory[x][y].card.data.tier == card.data.tier && not Inventory[x][y].card.data == card.data:
					return 2 #can combine
				elif Inventory[x][y].card.data == card.data:
					if card.data.canStack > 1:
						return 3 # can stack
						#stackCard(Vector2i(x, y), card)
				elif Inventory[x][y].card != null:
					return 0 #has card
	return 1 #empty


func stackCard(cellPos: Vector2i, card: CardBase)->void:
	if Inventory[cellPos.x][cellPos.y].canStack():
		Inventory[cellPos.x][cellPos.y].stackCount += 1
	else:
		push_warning("StackSizeFull or CannotStack")
		return


func removeCard(inventoryPos: Vector2i, card: CardBase)->void:
	var data = card.data
	if (inventoryPos + card.data.size) > Vector2i(columns, rows):
		push_error("Cannot place card outside of bounds | InvPos: ", card.data.size + inventoryPos)
		return
	
	for x in range(card.cellPosition.x ,card.cellPosition.x + card.data.size.x):
		for y in range(card.cellPosition.y ,card.cellPosition.y + card.data.size.y):
			if Inventory[x][y].card != card:
				push_error("Card is not in postion: ", inventoryPos) 
			else:
				Inventory[x][y].removeData()


func combineCards(card: CardBase, inventoryPos: Vector2i, cardTarget: CardBase)->void:
	pass


func addCard(inventoryPos: Vector2i, card: CardBase)->void:
	if (inventoryPos + card.data.size) > Vector2i(columns, rows):
		push_error("Cannot place card outside of bounds | InvPos: ", card.data.size + inventoryPos)
		return
	
	#check if the section has card in it already
	for y in range(card.cellPosition.y ,card.cellPosition.y + card.data.size.y):
		for x in range(card.cellPosition.x ,card.cellPosition.x + card.data.size.x):
			if Inventory[x][y].hasCard:
				push_error("CardAlreadyInSlot: ", Vector2i(x,y), " | InvPos: ", inventoryPos)
				return
	
	var centerPosArr = []
	for y in range(card.cellPosition.y ,card.cellPosition.y + card.data.size.y):
		for x in range(card.cellPosition.x ,card.cellPosition.x + card.data.size.x):
			Inventory[x][y].card = card
			centerPosArr.append(Inventory[x][y].getCenterPoint())
			print("Added card at: ", Vector2i(x,y))
	



func addToEmpty(card: CardBase)->void:
	for y in range(rows):
		for x in range(columns):
			if !Inventory[x][y].hasCard:
				var result = checkSlots(card, Vector2i(x,y))
				if result == 1: #clear slot
					setCard(Vector2i(x,y), card.data)
					return
	push_error("Inventory full.")


func _on_cell_pressed(invPosition: Vector2i, card: CardBase)->void:
	pickupCard(invPosition, card)


func _on_cell_released(invPosition: Vector2i, card: CardBase)->void:
	placeCard(invPosition, card)
#TODO: MAKE IT  SO WHEN THE TRAnsition would haPPEN like the tile is hovered and you release the drag the card gets placed in that slot but not before. if the drag is released then let it return to the old position.

func _on_cell_hovered(cellPosition: Vector2i)->void:
	currentCell = cellPosition
	print(currentCell)


func setCard(cellPosition: Vector2i, data: CardResource) -> CardBase:
	
	var newCard: CardBase = data.scene.instantiate()
	add_child(newCard)
	
	if (cellPosition + data.size) > Vector2i(columns, rows):
		push_error("Cannot place card outside of bounds | InvPos: ", data.size + cellPosition )
		return
	
	#check if the section has card in it already
	for y in range(cellPosition.y , cellPosition.y + data.size.y):
		for x in range(cellPosition.x , cellPosition.x + data.size.x):
			if Inventory[x][y].hasCard:
				push_error("CardAlreadyInSlot: ", Vector2i(x,y), " | InvPos: ", cellPosition )
				return
	
	var centerPosArr = []
	for y in range(cellPosition.y ,cellPosition.y + data.size.y):
		for x in range( cellPosition.x , cellPosition.x + data.size.x):
			Inventory[x][y].card = newCard
			centerPosArr.append(Inventory[x][y].getCenterPoint())
			print("Added card at: ", Vector2i(x,y))
		
	newCard._startup(centerPosArr, cellPosition) #ALWAYS ADD TO SCENE BEFORE SETTING VALUES LIKE GLOBAL POS BECAUSE OTHERWISE THEY WILL BE NONSENSE
	print(newCard)
	return newCard


func pickupCard(invPosition: Vector2i , card :CardBase)->void:
	pickupSlot = card
	removeCard(invPosition, card)


func placeCard(invPosition: Vector2i, card: CardBase)->void:
	pickupSlot = null
	placeCard(invPosition, card)


func _on_button_pressed() -> void:
	addToEmpty(basicCard)
