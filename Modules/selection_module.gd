extends Node2D

#public vars
var isSelected: bool = false

#public methods
func enable()->void: isSelected = true; show()
func diable()->void: isSelected = false; hide()
func toggle()->void: isSelected = !isSelected; visible = isSelected
