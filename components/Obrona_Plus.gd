extends Button


func _on_pressed():
	#zrobić to mądrzej niż odczekanie/czekać na sygnał z DiceManager
	await get_tree().create_timer(0.05).timeout
	var root = get_tree().current_scene
	if(Global.TestRzutu == 1):
		root.def(10)
		Global.TestRzutu = 0;
