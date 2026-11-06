class_name CollisionComponent extends Area2D
#----enums-----
#-----sub-components-----

@export var parent: Node2D

#-----signals-----
#-----variables-----

var collisionList: Array = []
var pushedForce: Vector2 = Vector2.ZERO

#-----private-----

func _physics_process(delta: float) -> void:
	_applyForces()
	
	_updateOwnForces(delta)
	

func _applyForces():
	for x in collisionList.size():
		var force = -collisionList[-x-1].global_position.direction_to(global_position)
		collisionList[-x-1].push(force)

func _updateOwnForces(delta: float)->void:
	parent.global_position += pushedForce * delta * 10 #calculate force? maybe use mass, assign a for each entitys collision component
	pushedForce = lerp(pushedForce, Vector2.ZERO, delta * 10.0)#maybe make a global friction constant

#-----public-----

func push(force:Vector2)->void:
	pushedForce += force
	#print("Pushed. Force is: ", force, " totalForce is: ", pushedForce)

#-----signal responses-----

func _on_area_entered(area: Area2D) -> void:
	collisionList.append(area)


func _on_area_exited(area: Area2D) -> void:
	collisionList.erase(area)
