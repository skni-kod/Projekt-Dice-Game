extends Resource
# 
class_name AttackDescription

@export var damage: int
@export var message: String
@export var effect: TemporaryEffect
@export var nextAttack: AttackDescription

func _init(damage_ = 0, message_ = "", effect_: TemporaryEffect = null, nextAttack_: AttackDescription = null):
	damage = damage_
	message = message_
	effect = effect_
	nextAttack = nextAttack_
