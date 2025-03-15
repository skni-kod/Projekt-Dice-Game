extends Area2D

class_name Level

#var level_completed = false
#var level_started = false
var levelNumber: int
var enemiesWave : Array[Wave]
var sprite: Sprite2D
var parentNode
var X
var Y
@onready var label = get_node("Label")

@onready var levelinfo = preload("res://scenes/level_info.tscn").instantiate()

func _init(n : int, waves : Array[Wave], pNode, x, y):
	X = x
	Y = y
	levelNumber = n
	enemiesWave = waves
	parentNode = pNode
	visible = true
	position = Vector2(X, Y)
	sprite = Sprite2D.new() #sprite z tekstutrą
	sprite.texture = load("res://resources/sprites/MapFightIcon.png")
	add_child(sprite)
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = sprite.texture.get_size() if sprite.texture else Vector2(64, 64)
	collision_shape.shape = shape
	add_child(collision_shape)

func _ready() -> void:
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	add_child(levelinfo)
	levelinfo.hide()

func find_node(nodeName : String):
	var parent = get_parent()
	while parent:
		if parent.name == "Map":
			var node = parent.get_node(nodeName)
			if node:
				return node
		parent = parent.get_parent()
	return null

#Po wciśnięciu przekazujemy dane do Labela, kótry wyświetli informacje o wybranym poziomie i 
# przekazujemy dane o potworach do levelManagera - plan taki, że to będzie jakoś przekazane do sceny głównej
#~Sebastian
func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#var poziom = int(str(name)[-1]) + 1
			var text = "Wybrany Poziom: " + str(levelNumber) + "\nFale: " + str(len(enemiesWave))
			for wave in enemiesWave:
				text += "\n"
				for enemy in wave.enemies:
					text += " " + str(enemy)
			var label = find_node("Label")
			var manager = find_node("LevelManager")
			if label:
				label.text = str(text)
			if GameManager.enemies.is_empty() and manager:
				manager.enemiesWave = enemiesWave
				manager.isLevelSelected = true
#Tutaj wyświetlamy taki dymek (levelInfo) nad najechanym poziomem
func _on_mouse_entered() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var text = "Poziom: " + str(levelNumber) + "\nFale: " + str(len(enemiesWave))
	text += "\n Przeciwnicy:"
	for wave in enemiesWave:
		text += "\n"
		for enemy in wave.enemies:
			text += " " + str(enemy)
	levelinfo.set_text(text)
	levelinfo.global_position = mouse_pos + Vector2(-180, -150)
	levelinfo.z_index = 101
	levelinfo.show()

func _on_mouse_exited() -> void:
	levelinfo.hide()
