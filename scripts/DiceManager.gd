extends Node2D
class_name DiceManager
signal Potwierdzenie
var dices = [];
var rng = RandomNumberGenerator.new()
var max_selected_dices = 3
var current_max_selected_dices = 0

func _ready() -> void:
	for child in get_children():
		dices.append(child as Dice)
	
func SelectedDiceCount() -> int:
	var c = 0
	for dice in dices:
		if dice.button_pressed:
			c = c + 1
	return c
		
func Roll() -> void:
	for dice in dices:
		dice.button_pressed = false
			
	for dice in dices:
		dice.Randomize(rng)
	
	current_max_selected_dices = max_selected_dices
		

func Reroll() -> void:
	current_max_selected_dices = current_max_selected_dices - SelectedDiceCount()
	for dice in dices:
		if dice.button_pressed:
			dice.button_pressed = false
			dice.Randomize(rng)
			
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
			dices[i].UpdateDisplay()
		Global.TestRzutu = 1;
		emit_signal("Potwierdzenie")
	return true
