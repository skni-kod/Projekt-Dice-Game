extends Area2D

class_name Level

var level_completed = false
var level_started = false
var level_accessible = true
var levelNumber: int
var levelLayer: int
var enemiesWave : Array[Wave]
var sprite: Sprite2D
var parentNodes : Array
var X: float
var Y: float
@onready var label = get_node("Label")

@onready var levelinfo = preload("res://scenes/level_info.tscn").instantiate()

func _init(n : int, waves : Array[Wave], pNodes : Array):
	levelNumber = n
	enemiesWave = waves
	parentNodes = pNodes
	visible = true
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
			var node = parent.get_node("Control")
			if node:
				node = node.get_node(nodeName)
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
			if level_started:
				return
			if not check_parent_nodes():
				return
			if not level_accessible:
				return
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
				label.visible = true
			if GameManager.enemies.is_empty() and manager:
				manager.enemiesWave = enemiesWave
				manager.isLevelSelected = true
				manager.selectedLevel = self

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

func update_visual_state_active() -> void:
	if sprite:
		sprite.texture = load("res://resources/sprites/MapActiveFightIcon.png")

func update_visual_state_completed() -> void:
	if sprite:
		sprite.texture = load("res://resources/sprites/MapCompletedFightIcon.png")

func update_visual_state_deactivated() -> void:
	if sprite:
		if not level_accessible and not level_started:
			sprite.texture = load("res://resources/sprites/MapDeactiveFightIcon.png")
		
func check_parent_nodes() -> bool:
	for parentNode in parentNodes:
		if parentNode.level_started:
			return true
	return false
