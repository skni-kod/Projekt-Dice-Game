extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	pass


func _on_wyjście_pressed():
	get_tree().change_scene_to_file("res://components/Menu/menu.tscn")
