extends Node2D

class_name LevelManager
# Called when the node enters the scene tree for the first time.

var levels: Array = [] 
var enemiesWave = []
var usableEnemies = ["goblin", "szlam"]
var isLevelSelected : bool = false
var nextLevelIndex = 2
var Paths

func _ready() -> void:
	Paths = get_child(0)
	var newLevel = create_first_level()
	levels.append(newLevel)
	add_child(newLevel[0])
	for i in range(3):
		var levelLayer = create_levels_layer(i, i + 1)
		levels.append(levelLayer)
		for lvl in levelLayer:
			add_child(lvl)
	for layer in levels:
		for lvl in layer:
			if lvl.parentNode:
				draw_paths(lvl)
	var button = get_node_or_null("../Button")
	if button:
		button.connect("pressed", Callable(self, "_on_button_pressed"))

#Rysujemy połączenie poziomów
func draw_paths(lvl):
	var parent = lvl.parentNode
	var line = Line2D.new()
	line.width = 4
	line.default_color = Color(0, 0, 0)
	line.add_point(Vector2(parent.X, parent.Y))
	line.add_point(Vector2(lvl.X, lvl.Y))
	Paths.add_child(line)

#Sprawdzamy czy został wybrany poziom, jeżeli tak to aktywujemy buttona
func _process(delta: float) -> void:
	var button = get_node_or_null("../Button")
	if button:
		button.visible = isLevelSelected

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/node_2d.tscn")

#funkcja do generowania fal potworow na podstawie dostepnych przeciwnikow
func generate_waves() -> Array:
	var amount_of_waves = randi_range(2, 4) # 2 do 4 fal
	var waves = []
	for i in range (amount_of_waves):
		var wave = []
		for j in range(randi_range(1,3)):
			var n = randi_range(0, len(usableEnemies) - 1)
			wave.append(usableEnemies[n])
		waves.append(wave)
	return waves

#pierwszy poziom
func create_first_level() -> Array:
	var waves = generate_waves()
	var level = Level.new(1, waves, null, 0, 0)
	return [level]

#generuje piętro poziomow
func create_levels_layer(previous_layer, current_layer) -> Array:
	var n = randi_range(1, 4)
	var levelsArr = []
	var k = 0
	for i in range(n):
		var waves = generate_waves()
		var parentIndex = randi_range(0, len(levels[previous_layer])-1)
		k = max(k, parentIndex) #zapewnienie, ze scieski nie beda sie ze soba krzyzowac
		var parentLevel = levels[previous_layer][k]
		var currentLevel = Level.new(nextLevelIndex, waves, parentLevel, calculate_x_pos(i, n), 0 - 180 * current_layer)
		nextLevelIndex += 1
		levelsArr.append(currentLevel)
	return levelsArr

#Funkcja do obliczania wspolzednej x okna poziomu
func calculate_x_pos(i, n):
	if n == 1:
		return 0
	if n == 2:
		return -200 + 400 * i
	if n == 3:
		return -300 + 300 * i
	if n == 4:
		return -450 + 300 * i 
