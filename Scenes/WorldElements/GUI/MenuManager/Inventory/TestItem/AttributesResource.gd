@tool
class_name ItemAttributes extends Resource

#-----enums-----

#-----sub-components-----

#-----signals-----

#-----variables-----
@export var value: int = 1
@export var effects: Dictionary[String, String]
@export var playable: bool = false
@export var texture: Texture2D
@export var unitSummon: PackedScene
#-----private-----

#-----public-----

#-----signal responses-----
