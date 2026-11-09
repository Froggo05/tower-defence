class_name SelectionModule extends Node2D

@onready var particle: GPUParticles2D = $PositionParticle

#public vars
var isSelected: bool = false

#public methods
func enable()->void: isSelected = true; show(); particle.emitting = true; particle.one_shot = false;
func diable()->void: isSelected = false; hide(); particle.emitting = false; particle.one_shot = true;
func trigger()->void: show(); particle.emitting = true; await particle.finished; hide()
func toggle()->void: isSelected = !isSelected; visible = isSelected; particle.emitting = isSelected; particle.one_shot = !isSelected;
