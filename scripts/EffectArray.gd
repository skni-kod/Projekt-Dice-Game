extends Node
# Klasa odpowiedzialna za zarządzanie zbiorem efektów, znajdujących się na przeciwniku lub graczu.
class_name EffectArray

@export var temporary_effects : Array[Effect] # Lista aktywnych efektów.
var effect_turn_duration : Array[int] # Lista liczb, gdzie na i-tej pozycji jest jak długo działa i-ty efekt.
var stats : Stats

func _ready() -> void:
	for e in temporary_effects:
		effect_turn_duration.append(0)

# Funkcja dodająca nowy tymczasowy efekt.
func AddTemporaryEffect(effect :Effect):
	if effect.ApplyFrequency.OnceAtBeggining:
		effect._ApplyEffect(stats)
		return
	temporary_effects.append(effect)
	effect_turn_duration.append(0)

# Funkcja, która powinna być wywoływana co turę, by zaktualizować działanie efektów.
func UpdateEffects():
	# Nałóż wszystkie efekty, które tego potrzebują i postarz je o jedną turę.
	for i in range(len(temporary_effects)):
		var effect = temporary_effects[i]
		if effect_turn_duration[i] >= effect.max_round_duration:
			return
		
		if effect.apply_frequency == Effect.ApplyFrequency.OnceAtBeggining or effect.apply_frequency == Effect.ApplyFrequency.OnceAtTheEnd:
			if effect.apply_frequency == Effect.ApplyFrequency.OnceAtBeggining && effect_turn_duration[0] == 0:
				effect._ApplyEffect(stats)
		else:
			effect._ApplyEffect(stats)
		
		effect_turn_duration[i] += 1
			
	# Sprawdź i usuń, efekty które się skończyły.
	temporary_effects.reverse()
	effect_turn_duration.reverse()
	for i in range(len(temporary_effects)):
		var effect = temporary_effects[i]
		if effect_turn_duration[i] >= effect.max_round_duration:
			if effect.apply_frequency == Effect.ApplyFrequency.OnceAtBeggining:
				effect.value = effect._InverseValue()
				effect._ApplyEffect(stats)
				effect.value = effect._InverseValue()
				
			elif effect.apply_frequency == Effect.ApplyFrequency.OnceAtTheEnd:
				effect._ApplyEffect(stats)
					
			temporary_effects.erase(effect)
	temporary_effects.reverse()
	effect_turn_duration.reverse()
