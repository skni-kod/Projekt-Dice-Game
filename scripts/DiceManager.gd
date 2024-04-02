extends Node2D

var dices = [];

func _ready() -> void:
	for child in get_children():
		dices.append(child as Dice)
			

func Roll() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for dice in dices:
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
			
	return true
