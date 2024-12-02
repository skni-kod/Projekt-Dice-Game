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

func RollOrReroll() ->void:
	if SelectedDiceCount() != 0:
		Reroll()
	else:
		Roll()
		
func Roll() -> void:
	var sound = $/root/main_scene/sound
	sound.play()
	for dice in dices:
		dice.button_pressed = false
			
	for dice in dices:
		dice.Randomize(rng)
	
	current_max_selected_dices = max_selected_dices
	Global.EndTurn()
		

func Reroll() -> void:
	var sound = $/root/main_scene/sound
	sound.play()
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
			if dices[i].button_pressed:
				dices[i].button_pressed = false
			dices[i].UpdateDisplay()
	return true
	
func ConsumeN(faceType, n) -> bool:
	var faces = []
	for i in range(n):
		faces.append(faceType)
		
	return Consume(faces);
