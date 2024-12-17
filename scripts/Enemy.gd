extends Node
# Klasa odpowiedzialna za zarządzanie przeciwnikiem.
class_name Enemy
	
var stats:Stats
@export var attacks : Array[AttackDescription]
var lastAttack : AttackDescription
var temporaryEffects : Array[TemporaryEffect]
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	stats = get_child(0) as Stats

# Funkcja dająca możliwość przeciwnikowi wykonania odpowiednich akcji.
func DoActions():
	var attack:AttackDescription
	if lastAttack and lastAttack.nextAttack:
		attack = lastAttack.nextAttack
	else:
		attack = attacks[rng.randi_range(0,attacks.size()-1)]
	lastAttack = attack
	
	# TO DO: Dodać wyświetlanie wiadomości
	$Stats/AttackMessage.text = str(attack.message)
	GameManager.player.stats.DealDamage(attack.damage)
	GameManager.EndEnemyTurn(self)
