extends Node

class_name EventChoice

var text: String
var effects: Dictionary
var output: String


func _init(_text: String, _output: String, _effects: Dictionary = {}):
	text = _text
	effects = _effects
	output = _output

func _ready() -> void:
	pass
