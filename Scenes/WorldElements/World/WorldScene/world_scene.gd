extends Node2D

@export var entityContainer: Node2D

func _ready() -> void:
	Global.worldScene = self


func _on_merchant_button_pressed() -> void:
	MenuManager.requestActiveMenuChange("MerchantMenu")


func _on_camp_button_pressed() -> void:
	MenuManager.requestActiveMenuChange("CampMenu")

func _on_forge_button_pressed() -> void:
	MenuManager.requestActiveMenuChange("ForgeMenu")
