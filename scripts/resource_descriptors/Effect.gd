extends Resource
# Zasób opisujący tymczasowy efekt.
class_name Effect

# Zbiór statystyk oddziaływania.
enum AffectedStat
{
	Health=0, BaseMaxHealth, MaxHealthMult, BaseDamage, DamageMult,BaseDamagePlus, DamagePlusMult, BaseDefence, DefenceMult,BaseDefencePlus, DefencePlusMult, ShouldRunAway, UsefulAttackChanceMult, AggresiveAttackChanceMult,
	ShouldSkipTurn, SpecialAttackChanceMult, AttackCost, AttackPlusCost, DefenceCost,DefencePlusCost,Special1Cost,Special2Cost,Special3Cost,Special4Cost
}

# Zbiór operacji.
enum Operation
{
	Add=0, Multiply,Set
}

# Zbiór częstotliwości nadawania efektu.
enum ApplyFrequency
{
	EveryTurn=0, OnceAtBeggining, OnceAtTheEnd
}

@export var affected_stat : AffectedStat # Statystyka, pierwszy operand operacji.
@export var operation : Operation # Operacja [affected_stat operacja value] np. health + 4.
@export var value : float # Wartość, drugi operand operacji
@export var cost : Array[Dice.FaceType] # Wykorzystywane do zmiany kosztów akcji.
@export var apply_frequency : ApplyFrequency # Częstotliwość nadawania efektu np. jednorazowo.
@export var max_round_duration : int # Długość działania efektu.
@export var is_positive : bool # Czy efekt jest pozytywny.

var last_value:float
var last_cost:Array[int]

func _init(affected_stat_ = AffectedStat.Health, operation_ = Operation.Add, value_ = 0.0, apply_frequency_ = ApplyFrequency.EveryTurn, max_round_duration_ = 0, is_positive_ = false):
	affected_stat = affected_stat_
	operation = operation_
	value = value_
	cost = []
	apply_frequency = apply_frequency_
	max_round_duration = max_round_duration_
	is_positive = is_positive_
	
func _ApplyOperation(operand):
	match operation:
		Operation.Multiply:
			if typeof(operand) == TYPE_ARRAY:
				push_error("Can't use Operation.Multiply with Costs")
			return float(operand) * value
		Operation.Add:
			if typeof(operand) == TYPE_ARRAY:
				return Array(operand) + cost
			return float(operand) + value
		Operation.Set:
			if typeof(operand) == TYPE_ARRAY:
				last_cost.clear()
				for v in operand:
					last_cost.append(int(v))
				print(last_cost)
				return cost
			last_value = operand
			return value
		_:
			return float(operand)
			
func _RevertOperation(operand):
	match operation:
		Operation.Multiply:
			if typeof(operand) == TYPE_ARRAY:
				push_error("Can't use Operation.Multiply with Costs")
			return float(operand) / value
		Operation.Add:
			if typeof(operand) == TYPE_ARRAY:
				Array(operand).erase(cost)
				return operand
			return float(operand) - value
		Operation.Set:
			if typeof(operand) == TYPE_ARRAY:
				return last_cost
			return last_value
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
		
		AffectedStat.BaseDamage:
			stats.SetBaseDamage(_ApplyOperation(stats.base_damage))
			
		AffectedStat.DamageMult:
			stats.SetDamageMult(_ApplyOperation(stats.damage_multiplier))
			
		AffectedStat.BaseDamagePlus:
			stats.SetBaseDamagePlus(_ApplyOperation(stats.base_damage))
			
		AffectedStat.DamagePlusMult:
			stats.SetAttackPlusMult(_ApplyOperation(stats.damage_multiplier))
			
		AffectedStat.BaseDefence:
			stats.SetBaseDefence(_ApplyOperation(stats.base_defence))
			
		AffectedStat.DefenceMult:
			stats.SetDefenceMult(_ApplyOperation(stats.defence_multiplier))
			
		AffectedStat.BaseDefencePlus:
			stats.SetBaseDefencePlus(_ApplyOperation(stats.base_defence))
			
		AffectedStat.DefencePlusMult:
			stats.SetDefencePlusMult(_ApplyOperation(stats.defence_multiplier))
		
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
			
		AffectedStat.AttackCost:
			stats.action_cost[ActionHandler.Action.Attack] = _ApplyOperation(stats.action_cost[ActionHandler.Action.Attack])
			
		AffectedStat.AttackPlusCost:
			stats.action_cost[ActionHandler.Action.AttackPlus] = _ApplyOperation(stats.action_cost[ActionHandler.Action.AttackPlus])
			
func _RevertEffect(stats: Stats):
	match affected_stat:
		AffectedStat.Health:
			stats.SetHealth(_RevertOperation(stats.health))
			
		AffectedStat.BaseMaxHealth:
			stats.SetBaseMaxHealth(_RevertOperation(stats.base_max_health))
			
		AffectedStat.MaxHealthMult:
			stats.SetMaxHealthMult(_RevertOperation(stats.max_health_multiplier))
		
		AffectedStat.BaseDamage:
			stats.SetBaseDamage(_RevertOperation(stats.base_damage))
			
		AffectedStat.DamageMult:
			stats.SetDamageMult(_RevertOperation(stats.damage_multiplier))
			
		AffectedStat.BaseDamagePlus:
			stats.SetBaseDamagePlus(_RevertOperation(stats.base_damage))
			
		AffectedStat.DamagePlusMult:
			stats.SetAttackPlusMult(_RevertOperation(stats.damage_multiplier))
			
		AffectedStat.BaseDefence:
			stats.SetBaseDefence(_RevertOperation(stats.base_defence))
			
		AffectedStat.DefenceMult:
			stats.SetDefenceMult(_RevertOperation(stats.defence_multiplier))
			
		AffectedStat.BaseDefencePlus:
			stats.SetBaseDefencePlus(_RevertOperation(stats.base_defence))
			
		AffectedStat.DefencePlusMult:
			stats.SetDefencePlusMult(_RevertOperation(stats.defence_multiplier))
		
		AffectedStat.ShouldRunAway:
			stats.should_run_away = _RevertOperation(stats.should_run_away)
			
		AffectedStat.UsefulAttackChanceMult:
			stats.useful_attack_chance_mult = _RevertOperation(stats.useful_attack_chance_mult)
		
		AffectedStat.AggresiveAttackChanceMult:
			stats.aggresive_attack_chance_mult = _RevertOperation(stats.aggresive_attack_chance_mult)
			
		AffectedStat.ShouldSkipTurn:
			stats.should_skip_turn = _RevertOperation(stats.should_skip_turn)
		
		AffectedStat.SpecialAttackChanceMult:
			stats.special_attack_chance_mult = _RevertOperation(stats.special_attack_chance_mult)
			
		AffectedStat.AttackCost:
			stats.action_cost[ActionHandler.Action.Attack] = _RevertOperation(stats.action_cost[ActionHandler.Action.Attack])
			
		AffectedStat.AttackPlusCost:
			stats.action_cost[ActionHandler.Action.AttackPlus] = _RevertOperation(stats.action_cost[ActionHandler.Action.AttackPlus])
