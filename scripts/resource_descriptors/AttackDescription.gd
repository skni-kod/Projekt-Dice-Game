extends Resource
# Zasób opisujący atak, np. przeciwnika.
class_name AttackDescription

@export var damage: int # Ilość zadawanych obrażeń.
@export var message: String # Wiadomość jaka ma być wyświetlana podczas ataku.
@export var effect: Effect # Opcjonalny efekt jaki ma być nadany na przeciwnika.
@export var weight: int # Waga używana do obliczania prawdopodobieństwa wybrania tego aktaku z puli.
@export var nextAttackSet: Array[AttackDescription]  # Opcjonalny następny atak.
@export var isUseful: bool # Czy atak jest bezużyteczny.
@export var isAggressive: bool # Czy atak jest agresywny.
@export var isSpecial: bool # Czy atak jest specjalny.

func _init(damage_ = 0, message_ = "", effect_: Effect = null, weight_ = 1, nextAttackSet_: Array[AttackDescription] = [], isUseful_ = false, isAggressive_ = false, isSpecial_ = false):
	damage = damage_
	message = message_
	effect = effect_
	weight = weight_
	nextAttackSet = nextAttackSet_
	isUseful = isUseful_
	isAggressive = isAggressive_
	isSpecial = isSpecial_
	
static func PickRandomAttack(attackSet: Array[AttackDescription]):
	var weightSum = 0
	for i in attackSet:
		weightSum += i.weight
	
	var r = GameManager.rng.randi_range(0,weightSum-1)
	var runningSum = 0
	for i in attackSet:
		runningSum += i.weight
		if runningSum > r:
			return i
			
	return attackSet[-1]
