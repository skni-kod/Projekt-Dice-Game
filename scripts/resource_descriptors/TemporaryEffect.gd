extends Resource
# Zasób opisujący tymczasowy efekt.
class_name TemporaryEffect

# Zbiór statystyk oddziaływania.
enum AffectedStat
{
	Health=0, MaxHealth, Attack, Defence	
}

# Zbiór operacji.
enum Operation
{
	Add=0, Multiply
}

# Zbiór częstotliwości nadawania efektu.
enum ApplyFrequency
{
	EveryTurn=0, Once
}

@export var affected_stat : AffectedStat # Statystyka, pierwszy operand operacji.
@export var operation : Operation # Operacja [affected_stat operacja value] np. health + 4.
@export var value : float # Wartość, drugi operand operacji
@export var apply_frequency : ApplyFrequency # Częstotliwość nadawania efektu np. jednorazowo.
@export var max_round_duration : int # Długość działania efektu.
var round_duration:int;

func _init(affected_stat_ = AffectedStat.Health, operation_ = Operation.Add, value_ = 0.0, apply_frequency_ = ApplyFrequency.EveryTurn, max_round_duration_ = 0):
	affected_stat = affected_stat_
	operation = operation_
	value = value_
	apply_frequency = apply_frequency_
	max_round_duration = max_round_duration_
	round_duration

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
			return operand * value
		Operation.Add:
			return operand + value
		_:
			return operand
		
func _ApplyEffect(stats: Stats):
	match affected_stat:
		AffectedStat.Health:
			stats.SetHealth(_ApplyOperation(stats.health))
			
		AffectedStat.MaxHealth:
			stats.SetMaxHealth(_ApplyOperation(stats.max_health))
		
		AffectedStat.Defence:
			stats.SetArmor(_ApplyOperation(stats.armor))

# Nałóż efekt na podaną statystykę.
func Apply(stats : Stats):
	if HasExpired():
		return
	
	if apply_frequency == ApplyFrequency.Once:
		if round_duration == 0:
			_ApplyEffect(stats)
	else:
		_ApplyEffect(stats)

	round_duration +=1

# Odwróć działanie efektu, używane dla efektów jednorazowych.
# Funkcja musi być wywoływana w kolejność odwrotnej do funkcji Apply().
func Expire(stats : Stats):
	if not HasExpired():
		return
		
	if not apply_frequency == ApplyFrequency.Once:
		return
	
	value = _InverseValue()
	_ApplyEffect(stats)
	value = _InverseValue()

# Zwraca Prawda, jeżeli efekt się już skończył.
func HasExpired():
	return round_duration >= max_round_duration
