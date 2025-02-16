extends Node2D

class_name LevelManager
# Called when the node enters the scene tree for the first time.

var levels: Array[Level] = [] 
var enemiesWave = []
var isLevelSelected : bool = false

func getChilds(level : Level) -> void:
	for child in level.get_children():
		if child is Level:
			levels.append(child)
			getChilds(child)


func _ready() -> void:
	for child in get_children():
		if child is Level:
			levels.append(child)
			getChilds(child)
	draw_paths()
	fill_levels_with_enemies()
	var button = get_node_or_null("../Button")
	if button:
		button.connect("pressed", Callable(self, "_on_button_pressed"))

#Rysujemy połączenie poziomów
func draw_paths():
	var paths_container = $Paths

	for level in levels:
		for child in level.get_children():
			if child is Level:
				var line = Line2D.new()
				line.default_color = Color(0, 0, 0)
				line.width = 5
				for ch in level.get_children():
					if ch is Sprite2D:
						line.add_point(ch.position)
				for ch in child.get_children():
					if ch is Sprite2D:
						line.add_point(ch.position)
				paths_container.add_child(line)

func fill_levels_with_enemies():
	levels[0].enemiesWave = [["goblin", "goblin"], ["goblin"], ["goblin", "goblin"], ["goblin"]]
	levels[1].enemiesWave = [["goblin", "goblin"], ["goblin"], ["goblin", "goblin"], ["goblin"]]
	levels[2].enemiesWave = [["goblin", "goblin"], ["goblin"], ["goblin", "goblin"], ["goblin"]]
	levels[3].enemiesWave = [["goblin", "goblin"], ["goblin"], ["goblin", "goblin"], ["goblin"]]

#Sprawdzamy czy został wybrany poziom, jeżeli tak to aktywujemy buttona
func _process(delta: float) -> void:
	var button = get_node_or_null("../Button")
	if button:
		button.visible = isLevelSelected

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/node_2d.tscn")
