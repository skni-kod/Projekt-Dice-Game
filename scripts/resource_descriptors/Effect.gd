extends Resource
# Zasób opisujący tymczasowy efekt.
class_name Effect

# Zbiór statystyk oddziaływania.
enum AffectedStat
{
	Health=0, BaseMaxHealth, MaxHealthMult, BaseAttack, AttackMult, Defence, ShouldRunAway, UsefulAttackChanceMult, AggresiveAttackChanceMult,
	ShouldSkipTurn, SpecialAttackChanceMult	
}

# Zbiór operacji.
enum Operation
{
	Add=0, Multiply
}

# Zbiór częstotliwości nadawania efektu.
enum ApplyFrequency
{
	EveryTurn=0, OnceAtBeggining, OnceAtTheEnd
}

@export var affected_stat : AffectedStat # Statystyka, pierwszy operand operacji.
@export var operation : Operation # Operacja [affected_stat operacja value] np. health + 4.
@export var value : float # Wartość, drugi operand operacji
@export var apply_frequency : ApplyFrequency # Częstotliwość nadawania efektu np. jednorazowo.
@export var max_round_duration : int # Długość działania efektu.
@export var is_positive : bool # Czy efekt jest pozytywny.

func _init(affected_stat_ = AffectedStat.Health, operation_ = Operation.Add, value_ = 0.0, apply_frequency_ = ApplyFrequency.EveryTurn, max_round_duration_ = 0, is_positive_ = false):
	affected_stat = affected_stat_
	operation = operation_
	value = value_
	apply_frequency = apply_frequency_
	max_round_duration = max_round_duration_
	is_positive = is_positive_

# Wartość odwrotna dla value, zależna od operacji, np dla dodawania zwróci -value.
func _InverseValue():
	match operation:
		Operation.Multiply:
			return 1 / value
		Operation.Add:
			return -value
		_: return value
	
func _ApplyOperation(operand):
	match operation:
		Operation.Multiply:
			return float(operand) * value
		Operation.Add:
			return float(operand) + value
		_:
			return float(operand)
		
func _ApplyEffect(stats: Stats):
	match affected_stat:
		AffectedStat.Health:
			stats.SetHealth(_ApplyOperation(stats.health))
			
		AffectedStat.BaseMaxHealth:
			stats.SetBaseMaxHealth(_ApplyOperation(stats.base_max_health))
			
		AffectedStat.MaxHealthMult:
			stats.SetMaxHealthMult(_ApplyOperation(stats.max_health_multiplier))
		
		AffectedStat.BaseAttack:
			stats.SetBaseAttack(_ApplyOperation(stats.base_attack))
			
		AffectedStat.AttackMult:
			stats.SetAttackMult(_ApplyOperation(stats.attack_multiplier))
		
		AffectedStat.Defence:
			stats.SetArmor(_ApplyOperation(stats.armor))
		
		AffectedStat.ShouldRunAway:
			stats.should_run_away = _ApplyOperation(stats.should_run_away)
			
		AffectedStat.UsefulAttackChanceMult:
			stats.useful_attack_chance_mult = _ApplyOperation(stats.useful_attack_chance_mult)
		
		AffectedStat.AggresiveAttackChanceMult:
			stats.aggresive_attack_chance_mult = _ApplyOperation(stats.aggresive_attack_chance_mult)
			
		AffectedStat.ShouldSkipTurn:
			stats.should_skip_turn = _ApplyOperation(stats.should_skip_turn)
		
		AffectedStat.SpecialAttackChanceMult:
			stats.special_attack_chance_mult = _ApplyOperation(stats.special_attack_chance_mult)
		
