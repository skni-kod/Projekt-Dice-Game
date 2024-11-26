extends Node2D


func _on_atak_mouse_entered():
	$Action_Description.text = str("Atak")

func _on_atak_mouse_exited():
	$Action_Description.text = str(" ")

func _on_atak_plus_mouse_entered():
	$Action_Description.text = str("Atak+")

func _on_atak_plus_mouse_exited():
	$Action_Description.text = str(" ")

func _on_obrona_mouse_entered():
	$Action_Description.text = str("Obrona")

func _on_obrona_mouse_exited():
	$Action_Description.text = str(" ")

func _on_obrona_plus_mouse_entered():
	$Action_Description.text = str("Obrona+")

func _on_obrona_plus_mouse_exited():
	$Action_Description.text = str(" ")

func _on_special_mouse_entered():
	$Action_Description.text = str("S1")

func _on_special_mouse_exited():
	$Action_Description.text = str(" ")

func _on_special_2_mouse_entered():
	$Action_Description.text = str("S2")

func _on_special_2_mouse_exited():
	$Action_Description.text = str(" ")

func _on_special_3_mouse_entered():
	$Action_Description.text = str("S3")

func _on_special_3_mouse_exited():
	$Action_Description.text = str(" ")

func _on_special_4_mouse_entered():
	$Action_Description.text = str("S4")

func _on_special_4_mouse_exited():
	$Action_Description.text = str(" ")

