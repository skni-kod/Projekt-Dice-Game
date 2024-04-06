extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/graj.grab_focus()


func _on_graj_pressed():
	get_tree().change_scene_to_file("res://components/node_2d.tscn")


func _on_opcje_pressed():
	get_tree().change_scene_to_file("res://components/Menu/opcje.tscn")


func _on_donejt_pressed():
	print("scam")
	
func _on_wyjście_pressed():
	get_tree().quit()

