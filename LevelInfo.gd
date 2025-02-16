extends Control

@onready var label = $Label2 #Label2, bo nie działał mi Label XD
@onready var background = $InfoBG

#Wyświetlanie tego dymka
func set_text(text: String) -> void:
	label.text = text
	await get_tree().process_frame
	var text_size = label.get_minimum_size() + Vector2(10, 5)
	label.size = text_size
	background.size = text_size + Vector2(10, 5)  
	size = background.size
