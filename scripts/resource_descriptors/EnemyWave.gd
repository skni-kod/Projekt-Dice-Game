extends Node
#klasa obslugujaca fale przeciwnikow
class_name Wave

var wave: Array = [] # Lista fal jako lista tekstów.
var remainingOpponents: int

func create_wave(n: int = 5):
	wave.clear()
	remainingOpponents = n
	for i in range(n):
		wave.append("goblin")
	print("dupa")
