class_name CardInventoryManager extends Control

@warning_ignore_start("unused_variable") 
@warning_ignore_start("unused_parameter")

@onready var SlotScene = preload("uid://crlm24wlk5oc0")
@onready var basicCard: CardBase = preload("uid://c5mkw4xmmuod1").instantiate()

var Inventory: Array = []

var columns: int = 10
var rows: int = 4


var pickupSlot: CardBase:
	set(newCard):
		if newCard == null:
			pickupSlot.pickedUp = false
			pickupSlot = newCard
			return
		else:
			newCard.pickedUp = true
			pickupSlot = newCard
	get():
		return pickupSlot

var hoveredCell: Vector2i:
	set(value):
		#print("hoveredCellChanged", value)
		hoveredCell = value
	get():
		return hoveredCell

@export var slotContainer: GridContainer
@export var cardDragFactor: float = 5.0

var moveSpeed: float = 5.0
var targetPosition: Vector2 = Vector2.ZERO

enum SLOT {
	ERROR = -2,
	OUTOFBOUNDS = -1,
	FULL = 0,
	EMPTY = 1,
	COMBINE = 2,
	STACKABLE = 3
}


func moveToTarget(delta: float)->void:
	if targetPosition != Vector2.ZERO:
		global_position = global_position.lerp(targetPosition, delta*moveSpeed)
		var approxTarget = Vector2(0.001,0.001)
		if targetPosition.snapped(approxTarget) == global_position.snapped(approxTarget):
			targetPosition = Vector2.ZERO
			print("Stop move to Target")


func _process(delta: float) -> void:
	moveToTarget(delta)
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
			newSlot.mouseReleased.connect(_on_cell_released)
			
			newSlot.slotPosition = Vector2i(column, row)
			newSlot.label.text = newSlot.name
			#print(newSlot.global_position)
	#print(Inventory)


func checkSlots(cellPosition: Vector2i, card: CardBase)->SLOT:
	
	var cardMaxBounds: Vector2i = (cellPosition + card.data.size)
	if cardMaxBounds.x > columns or cardMaxBounds.y > rows:
		print(SLOT.OUTOFBOUNDS)
		return SLOT.OUTOFBOUNDS
	
	var cardInASlot:bool = false
	
	for y in range(cellPosition.y ,cellPosition.y + (card.data.size.y)):
		for x in range(cellPosition.x , cellPosition.x + (card.data.size.x)):
			#print("Checking x: ",x, " y: ", y)
			#print(Inventory[x][y].hasCard)
			if Inventory[x][y].hasCard:
				cardInASlot = true
				if Inventory[x][y].card.data.tier == card.data.tier && not Inventory[x][y].card.data.name == card.data.name: 
					#will have to add some sort of combo recipies prob use dict in resource?
					return SLOT.COMBINE
				
				#print(Inventory[x][y].card.data.name, " ", card.data.name)
				if Inventory[x][y].card.data.name == card.data.name:
					if Inventory[x][y].card.checkCanStack(card):
						return SLOT.STACKABLE
						
				
				if Inventory[x][y].card != null:
					push_warning("INVENTORYSLOT IS FULL", Vector2i(x, y))
					return SLOT.FULL
	
	if cardInASlot:
		return SLOT.ERROR
	else:
		return SLOT.EMPTY

func removeCard(cellPosition: Vector2i, card: CardBase)->void:
	if checkSlots(cellPosition, card) == SLOT.OUTOFBOUNDS:
		push_error("Cannot Remove Card Out of Bounds")
		return

	for x in range(cellPosition.x , cellPosition.x + card.data.size.x):
		for y in range(cellPosition.y ,cellPosition.y + card.data.size.y):
				Inventory[x][y].removeCardInSlot()


func combineCards(card: CardBase, inventoryPos: Vector2i, cardTarget: CardBase)->void:
	pass


func setCardPos(cardPosition: Vector2i, card: CardBase)->void:
	var cardSize = card.data.size
	var centerPosArr = []
	for y in range(cardPosition.y ,cardPosition.y + cardSize.y):
		for x in range(cardPosition.x, cardPosition.x + cardSize.x):
			#print("Set card to, ", Vector2i(x, y))
			Inventory[x][y].card = card
			centerPosArr.append(Inventory[x][y].getCenterPoint())
			#print("Added card at: ", Vector2i(x,y))
	card.moveCard(centerPosArr, cardPosition)


#add card to a position in the inventory
func addCard(newCellPosition: Vector2i, card: CardBase)->void:
	var check = checkSlots(newCellPosition, card)
	#print(check)
	if check == SLOT.OUTOFBOUNDS:
		push_error("Cannot Add Card Out of Bounds")
		print_stack()
		return
	#check if the section has card in it already
	if  check == SLOT.EMPTY:
		setCardPos(newCellPosition, card)


func addToEmpty(card: CardBase)->void:
	for y in range(rows):
		for x in range(columns):
			if !Inventory[x][y].hasCard:
				var check = checkSlots(Vector2i(x,y), card)
				if check == SLOT.ERROR:
					push_error("SLOT.ERROR ", Vector2i(x, y))
				if check == SLOT.EMPTY:
					createCard(Vector2i(x,y), CardResource.new())
					return
	push_warning("Inventory full.")


func createCard(cellPosition: Vector2i, data: CardResource) -> CardBase:
	var newCard: CardBase = data.scene.instantiate()
	
	var cardResult:int = checkSlots(cellPosition, newCard)
	if cardResult != SLOT.EMPTY:
		push_error("cardSlotNotEmpty: ", cellPosition)
		return
	
	
	var centerPosArr = []
	for y in range(cellPosition.y ,cellPosition.y + data.size.y):
		for x in range( cellPosition.x , cellPosition.x + data.size.x):
			Inventory[x][y].card = newCard
			centerPosArr.append(Inventory[x][y].getCenterPoint())
			#print("Added card at: ", Vector2i(x,y))
	
	add_child(newCard)
	newCard._startup(centerPosArr, cellPosition) #ALWAYS ADD TO SCENE BEFORE SETTING VALUES LIKE GLOBAL POS BECAUSE OTHERWISE THEY WILL BE NONSENSE
	#print(newCard)
	return newCard



func _on_cell_hovered(cellPosition: Vector2i)->void: hoveredCell = cellPosition
func _on_cell_pressed(invPosition: Vector2i, card: CardBase)->void: pickupCard(invPosition, card)
func _on_cell_released()->void:
	if pickupSlot == null:
		return
	
	var checkSlotResult :int = checkSlots(hoveredCell, pickupSlot)
	
	if checkSlotResult == SLOT.OUTOFBOUNDS:
		#check if slots above are clear (-1 for array allignment with size)
		if checkSlots(hoveredCell- Vector2i(0, pickupSlot.data.size.y -1), pickupSlot) == SLOT.EMPTY:
			hoveredCell -=  Vector2i(0, pickupSlot.data.size.y -1)
			placeCard()
			return
	
	
	if hoveredCell == Vector2i(-1,-1) or hoveredCell == pickupSlot.cellPosition :
		dropCard()
		return	
	
	
	if checkSlotResult == SLOT.STACKABLE:
		if Inventory[hoveredCell.x][hoveredCell.y].card.checkCanStack(pickupSlot):
			stackCard(Inventory[hoveredCell.x][hoveredCell.y].card)
			print("Stacking Card")
			return
		else:
			dropCard()
			return
	
	if checkSlotResult == SLOT.EMPTY:
		print("Placing Card")
		#print(Inventory[hoveredCell.x][hoveredCell.y].card.data.name, " ", pickupSlot.data.name)
		placeCard()


func pickupCard(invPosition: Vector2i , card :CardBase)->void:
	pickupSlot = card


func placeCard()->void:
	removeCard(pickupSlot.cellPosition, pickupSlot)
	addCard(hoveredCell, pickupSlot)
	pickupSlot = null


func stackCard(card: CardBase)->void:
	card.addToStack(pickupSlot)
	removeCard(pickupSlot.cellPosition, pickupSlot)
	pickupSlot.queue_free()
	pickupSlot = null


func dropCard()->void:
	pickupSlot = null


func _on_button_pressed() -> void:
	addToEmpty(basicCard)
