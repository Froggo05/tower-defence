class_name AttackComponent extends Area2D

var enemyInRange: bool = false
var target: HealthComponent

@export var timer: float = 0.0
@export var attackCooldown: float = 1.0/12 * 8.0
var canAttack: bool = true


@export var damage: float = 1.0

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if enemyInRange:
		_attack(delta)

func _attack(delta: float)->void:
	attackTimer(delta)
	if canAttack:
		if target.isDead:
			target = null
			enemyInRange = false
			return
		target.damage(damage)
		owner.setState(DynamicEntity.STATE.ATTACK)
		canAttack = false

func _on_area_entered(area: Area2D) -> void:
	if area is HealthComponent:
		target = area as HealthComponent
		enemyInRange = true

func attackTimer(delta: float)->void:
	if canAttack:
		return
	timer += delta
	if timer >= attackCooldown:
		timer -= attackCooldown
	canAttack = true


func _on_area_exited(area: Area2D) -> void:
	if area is HealthComponent:
		target = null
		enemyInRange = false
