extends Resource
class_name Action

@export var name : String
@export var cost : Array[Dice.FaceType]
@export var effects : Array[Effect]
@export var isArea : bool

func _init():
	name = ""
	cost = []
	effects = []
	isArea = false
