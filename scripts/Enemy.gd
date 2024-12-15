extends Node
class_name Enemy
	
var stats:Stats
@export var attacks : Array[AttackDescription]
var lastAttack : AttackDescription
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	stats = get_child(0) as Stats

func DoActions():
	var attack:AttackDescription
	if lastAttack and lastAttack.nextAttack:
		attack = lastAttack.nextAttack
	else:
		attack = attacks[rng.randi_range(0,attacks.size()-1)]
	lastAttack = attack
	
	# TO DO: Dodać wyświetlanie wiadomości
	print(attack.message)
	if attack.effect:
		GameManager.player.temporaryEffects.append(attack.effect)
	
	GameManager.player.stats.DealDamage(attack.damage)
	GameManager.EndEnemyTurn()
