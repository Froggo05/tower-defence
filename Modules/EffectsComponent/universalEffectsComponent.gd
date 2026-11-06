@tool
class_name UniversalEffectsComponent extends Node2D

#Actually super elegant solution. Will need to use object pooling for units cause this code will be expensive with a lot of them
#my own mind ^

#AI CODE ALERT HERE:

const FLASH_SHADER: = preload("uid://bktff25qsvypq")

var _sprites: Array[Sprite2D] = []
var _flash_amount: float = 0.0
var _flash_colour: Color = Color.RED


@export_range(0.0, 1.0) var flash_amount: float:
	set(value):
		_flash_amount = clampf(value, 0.0, 1.0)
		for sprite in _sprites:
			var mat := sprite.material as ShaderMaterial
			if mat:
				mat.set_shader_parameter("flash_amount", _flash_amount)
	get:
		return _flash_amount
@export var flash_colour: Color:
	set(value):
		_flash_colour = value
		for sprite in _sprites:
			var mat := sprite.material as ShaderMaterial
			if mat:
				mat.set_shader_parameter("flash_colour", _flash_colour)
	get:
		return _flash_colour
@export var animationPlayer: AnimationPlayer

func _ready() -> void:
	for node in animationPlayer.get_parent().find_children("*", "Sprite2D", true, false):
		var sprite := node as Sprite2D
		var mat := ShaderMaterial.new()
		mat.shader = FLASH_SHADER
		mat.set_shader_parameter("flash_amount", _flash_amount)
		mat.set_shader_parameter("flash_colour", _flash_colour)
		sprite.material = mat
		_sprites.append(sprite)
