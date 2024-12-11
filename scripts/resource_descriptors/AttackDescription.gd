extends Resource
class_name AttackDescription

@export var damage: int
@export var message: String
@export var nextAttack: AttackDescription

func _init(damage_ = 0, message_ = "", nextAttack_: AttackDescription = null):
	damage = damage_
	message = message_
	nextAttack = nextAttack_
