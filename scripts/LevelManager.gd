extends Node2D

class_name LevelManager
# Called when the node enters the scene tree for the first time.

var levels: Array[Level] = [] 

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
