extends Node2D
# Klasa odpowiedzialna za zarządzanie zbiorem kości.
class_name DiceManager

var dices = [];
var rng = RandomNumberGenerator.new()
var max_selected_dices = 3
var current_max_selected_dices = 0

func _ready() -> void:
	for child in get_children():
		dices.append(child as Dice)

# Policz ile jest zaznaczonych kości.
func SelectedDiceCount() -> int:
	var c = 0
	for dice in dices:
		if dice.button_pressed:
			c = c + 1
	return c

# Jeżeli są jakieś zaznaczone kości to je przerzuć, inaczej rzuć wszystkimi kośćmi.
func RollOrReroll() ->void:
	if SelectedDiceCount() != 0:
		Reroll()
	else:
		Roll()
	
# Rzuć wszystkimi kośćmi.
func Roll() -> void:
	var sound = $/root/main_scene/sound
	sound.play()
	for dice in dices:
		dice.button_pressed = false
			
	for dice in dices:
		dice.Randomize(rng)
	
	current_max_selected_dices = max_selected_dices
	GameManager.player.EndTurn()
		
# Przerzuć aktualnie zaznaczone kości.
func Reroll() -> void:
	var sound = $/root/main_scene/sound
	sound.play()
	current_max_selected_dices = current_max_selected_dices - SelectedDiceCount()
	for dice in dices:
		if dice.button_pressed:
			dice.button_pressed = false
			dice.Randomize(rng)

# Jeżeli na zbiorze kości znajdują się wszystkie ścianki z listy faceTypes,
# to zmień je na puste, i zwróć Prawda, w przeciwnym wypadku zwróć Fałsz.
# Typy ścianek w liście faceTypes mogą się powtarzać.	
func Consume(faceTypes = []) -> bool:
	var claimedDices = []
	for i in range(dices.size()):
		claimedDices.append(false)

	for type in faceTypes:
		var containsType = false
		for i in range(dices.size()):
			if dices[i].currentFace == type and claimedDices[i] == false:
				containsType = true
				claimedDices[i] = true
				break

		if !containsType:
			return false

	for i in range(dices.size()):
		if claimedDices[i] == true:
			dices[i].currentFace = Dice.FaceType.Blank
			if dices[i].button_pressed:
				dices[i].button_pressed = false
			dices[i]._UpdateDisplay()
	return true
	
# Wariant funkcji Consume, konsumujący N ścianek tego samego typu.
func ConsumeN(faceType, n) -> bool:
	var faces = []
	for i in range(n):
		faces.append(faceType)
		
	return Consume(faces);
