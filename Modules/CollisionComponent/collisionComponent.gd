class_name CollisionComponent extends Area2D
#----enums-----
#-----sub-components-----
@export var parent: Entity
#-----signals-----
#-----variables-----
@export var pushable: bool = true
@export var canPush: bool = true
var collisionList: Array = []
var pushedForce: Vector2 = Vector2.ZERO
@export var maxPushesPerFrame: int = 10
@export var pushFactor: float = 10.0

#-----private-----
func _physics_process(delta: float) -> void:
	_applyForces()
	_updateOwnForces(delta)
	

func _applyForces():
	if !canPush:
		return
	for x in collisionList.size(): #collisionList.size()
		if x >= maxPushesPerFrame:
			break
		var force = -collisionList[-x-1].global_position.direction_to(global_position) * pushFactor
		#print("Pushing: ", collisionList[-x-1].parent.name, " by ", parent.name)
		collisionList[-x-1].push(force)

func _updateOwnForces(delta: float)->void:
	if !pushable:
		return
	parent.global_position += round(pushedForce * delta * 10) #calculate force? maybe use mass, assign a for each entitys collision component
	pushedForce = lerp(pushedForce, Vector2.ZERO, clamp(delta * 10.0, 0.0, 1.0))#maybe make a global friction constant
#-----public-----

func push(force:Vector2)->void:
	pushedForce += force
	#print("Pushed. Force is: ", force, " totalForce is: ", pushedForce)

#-----signal responses-----

func _on_area_entered(area: Area2D) -> void:
	collisionList.append(area)

func _on_area_exited(area: Area2D) -> void:
	collisionList.erase(area)
