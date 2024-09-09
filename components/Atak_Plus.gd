extends Button
var root;

func _on_pressed():
	#zrobić to mądrzej niż odczekanie/czekać na sygnał z DiceManager
	await get_tree().create_timer(0.05).timeout
	var root = get_tree().current_scene
	if(Global.TestRzutu == 1):
		Global.harm(20)
		Global.TestRzutu = 0;
