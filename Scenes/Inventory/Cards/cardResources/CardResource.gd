class_name CardResource
extends Resource

enum CardRarity {
	BASIC,
	UNCOMMON,
	RARE,
	LEGENDARY
}
@export var name: String = "Null"
@export var stats: Dictionary = {"Damage" : 1.0, "Health" : 100.0, "Value" : 1}
@export var size: Vector2i = Vector2i(1, 2)
@export var tier: int = 0
@export var invPos: Vector2i = Vector2i.ZERO
@export var stackSize: int = 10

@export var cardUUID: String = "uid://c5mkw4xmmuod1" #BasicCard by default legacy? going to use cardContainer from now on if possible (a card but it takes the resource inside and morphs into that card type)
@export var isMaterial: bool = false
@export var rarity: int = CardRarity.BASIC #basic by default
@export var texture: Texture2D

static var scene: PackedScene

func _init() -> void:
	if scene == null:
		scene = load(cardUUID)
