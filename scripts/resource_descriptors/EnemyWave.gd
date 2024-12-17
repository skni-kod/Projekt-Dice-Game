extends Node
#klasa obslugujaca fale przeciwnikow
class_name Wave

@export var enemies: Array[String] # Lista przeciwników jako lista tekstów.

func _init(enemies_:Array[String] = []):
	enemies = enemies_
