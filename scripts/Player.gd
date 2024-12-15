extends Node
class_name Player

var stats:Stats
var temporaryEffects : Array[TemporaryEffect]

func _ready() -> void:
	stats = get_child(0) as Stats

func DoActions():
	pass
	
func EndTurn():
	GameManager.EndPlayerTurn()
