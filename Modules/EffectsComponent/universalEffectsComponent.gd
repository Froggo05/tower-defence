@tool class_name UniversalEffectsComponent extends Node2D

const FLASH_SHADER: = preload("uid://bktff25qsvypq")

var _sprites: Array[AnimatedSprite2D] = []
var _flash_amount: float = 0.0
var _flash_colour: Color = Color.RED
@export var animations: Dictionary[String,Node2D]

func restart(animation: String)->void:
	for child in animations[animation].get_children():
		child.restart()

@export_range(0.0, 1.0) var flash_amount: float:
	set(value):
		_flash_amount = clampf(value, 0.0, 1.0)
		for sprite in _sprites:
			var mat: ShaderMaterial= sprite.material as ShaderMaterial
			if mat:
				mat.set_shader_parameter("flash_amount", _flash_amount)
	get:
		return _flash_amount
@export var flash_colour: Color:
	set(value):
		_flash_colour = value
		for sprite in _sprites:
			var mat: ShaderMaterial = sprite.material as ShaderMaterial
			if mat:
				mat.set_shader_parameter("flash_colour", _flash_colour)
	get:
		return _flash_colour
@export var animationPlayer: AnimationPlayer

func _ready() -> void:
	for node in animationPlayer.get_parent().find_children("*", "AnimatedSprite2D", true, false):
		var sprite: AnimatedSprite2D = node as AnimatedSprite2D
		var shaderMaterial: ShaderMaterial = ShaderMaterial.new()
		shaderMaterial.shader = FLASH_SHADER
		shaderMaterial.set_shader_parameter("flash_amount", _flash_amount)
		shaderMaterial.set_shader_parameter("flash_colour", _flash_colour)
		sprite.material = shaderMaterial
		_sprites.append(sprite)
