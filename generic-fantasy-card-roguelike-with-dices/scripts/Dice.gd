class_name Dice
extends Sprite2D

enum FaceType
{
	Blank = 0, Attack, Defense, Special, Last = Special
}

var currentFace = FaceType.Blank

func _ready()->void:
	currentFace = FaceType.Blank
	UpdateDisplay()
	
	
func Randomize(rng:RandomNumberGenerator) -> void:
	currentFace = rng.randi_range(1, FaceType.Last) as FaceType
	UpdateDisplay()


func UpdateDisplay() -> void:
	if currentFace == FaceType.Blank:
		texture = null
	else:
		texture = load("res://data/sprites/" + FaceType.keys()[currentFace].to_lower() +".png")
