extends Node2D

class_name LevelManager
# Called when the node enters the scene tree for the first time.

var levels: Array = [] 
var enemiesWave: Array[Wave]
var usableEnemies = ["goblin", "szlam"]
var isLevelSelected : bool = false
var nextLevelIndex = 2
var Paths : Line2D
var currentLevel: Level
var selectedLevel: Level
var numberOfLayers: int = 8
var button

func _ready() -> void:
	Paths = get_child(0)
	var newLevel = create_first_level()
	levels.append(newLevel)
	currentLevel = newLevel[0]
	add_child(newLevel[0])
	for i in range(numberOfLayers - 2):
		var levelLayer = create_levels_layer(i, i + 1)
		levels.append(levelLayer)
		for lvl in levelLayer:
			add_child(lvl)
	newLevel = create_boss_level()
	levels.append(newLevel)
	add_child(newLevel[0])
	calculatePosition(levels)
	for layer in levels:
		for lvl in layer:
			draw_paths(lvl)
	button = get_node_or_null("../Button")
	if button:
		button.connect("pressed", Callable(self, "_on_button_pressed"))

#Rysujemy połączenie poziomów
func draw_paths(lvl):
	for parent in lvl.parentNodes:
		#var parent = lvl.parentNode
		if parent != null:
			var line = Line2D.new()
			line.width = 2
			line.default_color = Color(0, 0, 0)
			line.add_point(Vector2(parent.X, parent.Y))
			line.add_point(Vector2(lvl.X, lvl.Y))
			Paths.add_child(line)

#Sprawdzamy czy został wybrany poziom, jeżeli tak to aktywujemy buttona
func _process(delta: float) -> void:
	if button:
		button.visible = isLevelSelected
	var speed: int
	if numberOfLayers < 10:
		speed = 150
	else:
		speed = 200
	if Input.is_action_pressed("ui_up"):
		position.y += speed * delta
	elif Input.is_action_pressed("ui_down"):
		position.y -= speed * delta
	var upper_limit := 165
	var lower_limit := 180 + (numberOfLayers - 4) * 50
	#oś Y jest odwrócona
	#                  wartosc     min           max
	position.y = clamp(position.y, upper_limit, lower_limit)

func _on_button_pressed() -> void:
	if selectedLevel is Event:
		var event_scene = load("res://scenes/event.tscn")
		var instance = event_scene.instantiate()
		var container := get_node("/root/Map/Control")
		container.add_child(instance)
	elif selectedLevel is Level:
		get_tree().root.get_node("Map").visible = false
		GameManager.enemy_waves = enemiesWave
		GameManager.current_wave = 0
		GameManager.SpawnWave(GameManager.enemy_waves[0])
		GameManager.diceManager.Reroll()
		if currentLevel:
			currentLevel.level_completed = true
			currentLevel.update_visual_state_completed()
		currentLevel = selectedLevel
		for lvl in levels[currentLevel.levelLayer]:
			lvl.level_accessible = false
			lvl.update_visual_state_deactivated()
		currentLevel.level_started = true
		currentLevel.update_visual_state_active()
		selectedLevel = null
		isLevelSelected = false
		button.visible = false


#funkcja do generowania fal potworow na podstawie dostepnych przeciwnikow
func generate_waves() -> Array[Wave]:
	var amount_of_waves = randi_range(2, 4) # 2 do 4 fal
	var waves: Array[Wave]
	for i in range (amount_of_waves):
		var wave = Wave.new()
		for j in range(randi_range(1,3)):
			var n = randi_range(0, len(usableEnemies) - 1)
			wave.enemies.append(usableEnemies[n])
		waves.append(wave)
	return waves

#pierwszy poziom
func create_first_level() -> Array:
	var waves: Array[Wave]
	var first_wave = Wave.new()
	first_wave.enemies.append("goblin")
	first_wave.enemies.append("goblin")
	waves.append(first_wave)
	var level = Level.new(1, waves, [null])
	level.level_started = true
	level.update_visual_state_active()
	level.levelLayer = 0
	return [level]

#Ostatni poziom - goblin jest do zmiany na bossa jak bedzie gotowy
func create_boss_level() -> Array:
	var wave = Wave.new()
	wave.enemies.append("goblin")
	var level = Level.new(levels[len(levels)-1][len(levels[len(levels) - 1]) - 1].levelNumber + 1, [wave], levels[len(levels) - 1])
	return [level]

#generuje piętro poziomow
func create_levels_layer(previous_layer, current_layer) -> Array:
	var n = randi_range(1, 4)
	var levelsArr = []
	var k = 0
	var parentsIndexes = create_levels_parents(n, len(levels[previous_layer]))
	var parents = []
	for index in parentsIndexes:
		var parentsArray : Array[Level]
		for parent in index:
			parentsArray.push_back(levels[previous_layer][parent])
		parents.push_back(parentsArray)
	for i in range(n):
		var fightProbability = randi_range(0, 10)
		if fightProbability < 8:
			var waves = generate_waves()
			var currentlyGeneratedLevel = Level.new(nextLevelIndex, waves, parents[i])
			currentlyGeneratedLevel.levelLayer = current_layer
			nextLevelIndex += 1
			levelsArr.append(currentlyGeneratedLevel)
		else: 
			var currentlyGeneratedLevel = Event.new(nextLevelIndex, parents[i])
			currentlyGeneratedLevel.levelLayer = current_layer
			nextLevelIndex += 1
			levelsArr.append(currentlyGeneratedLevel)
	return levelsArr


func create_levels_parents(curr : int, prev : int ) -> Array:
	var parents = []
	if prev == 1:
		for i in range (curr):
			parents.push_back([0])
		return parents
	if curr == 1:
		var par = []
		for i in range (prev):
			par.push_back(i)
			parents.push_back(par)
		return parents
	if curr == 2:
		if prev == 2:
			var options = [[[0], [1]], [[0,1], [1]], [[0], [0,1]]]
			var n = randi_range(0, len(options)-1)
			return options[n]
		if prev == 3:
			var options = [[[0], [1, 2]],[[0, 1], [2]], [[0, 1], [1, 2]]]
			var n = randi_range(0, len(options)-1)
			return options[n]
		if prev == 4:
			var options = [[[0, 1], [2,3]],[[0], [1,2,3]], [[0,1,2], [3]]]
			var n = randi_range(0, len(options)-1)
			return options[n]
	if curr == 3:
		if prev == 2:
			var options = [[[0], [0,1], [1]], [[0], [1], [1]], [[0],[0],[1]]]
			var n = randi_range(0, len(options)-1)
			return options[n]
		if prev == 3:
			var options = [[[0], [1], [2]], [[0,1], [1], [2]], [[0],[1,2],[2]], [[0,1],[1,2],[2]], [[0], [0,1], [2]], 
			[[0], [1], [1,2]], [[0], [0,1], [1,2]], [[0,1], [1], [1,2]], [[0], [0,1,2], [2]]]
			var n = randi_range(0, len(options)-1)
			return options[n]
		if prev == 4:
			var options = [[[0], [1,2], [3]], [[0,1], [1,2], [3]], [[0,1], [1,2], [2,3]], [[0], [1], [2,3]],
			[[0,1], [2], [3]], [[0,1], [1], [2,3]], [[0,1], [2], [2,3]]]
			var n = randi_range(0, len(options)-1)
			return options[n]
	if curr == 4:
		if prev == 2:
			var options = [[[0], [0], [1], [1]], [[0], [1], [1], [1]], [[0], [0], [0], [1]], [[0], [0,1], [1], [1]], [[0], [0], [0,1], [1]]]
			var n = randi_range(0, len(options)-1)
			return options[n]
		if prev == 3:
			var options = [[[0], [1], [1], [2]], [[0],[0,1],[1,2],[2]], [[0], [0,1], [2], [2]], [[0],[1],[1,2],[2]],
			[[0],[0,1],[1],[2]]]
			var n = randi_range(0, len(options)-1)
			return options[n]
		if prev == 4:
			var options = [[[0], [1], [2], [3]], [[0],[0],[1],[2,3]], [[0,1],[2],[3],[2,3]], [[0,1],[1,2],[2,3],[3]],[[0],[0,1],[1,2],[2,3]],
			[[0,1],[1],[2],[3]], [[0],[1,2],[2],[3]], [[0],[1],[2,3],[3]], [[0],[0,1],[2],[3]], [[0],[1],[1,2],[3]], [[0],[1],[2],[2,3]],
			[[0], [0,1], [1,2], [3]], [[0], [1], [1,2], [2,3]], [[0], [0,1], [2], [2,3]], [[0,1], [1,2], [2], [3]], [[0], [1,2], [2,3], [3]], 
			[[0,1], [1], [2,3], [3]], [[0], [1,2], [2,3], [3]], [[0], [1], [1,2,3], [3]], [[0,1], [1], [1,2,3], [3]], [[0], [0,1], [1,2,3], [3]],
			[[0], [0,1,2], [2], [3]], [[0], [0,1,2], [2,3], [3]], [[0], [0,1,2], [2], [2,3]], [[0], [0,1], [2,3], [3]], [[0,1], [1], [2], [2,3]]]
			var n = randi_range(0, len(options)-1)
			return options[n]
	return  []

#Funkcja do obliczania wspolrzednej x ikonki poziomu
func calculate_x_pos(i, n):
	if n == 1:
		return 0
	if n == 2:
		return -100 + 200 * i
	if n == 3:
		return -100 + 100 * i
	if n == 4:
		return -140 + 90 * i 

#Funkcja do obliczania wspolrzednej x i y ikonki poziomu
func calculatePosition(arr : Array) -> void:
	for i in range(numberOfLayers):
		for j in range (len(arr[i])):
			arr[i][j].position = Vector2(calculate_x_pos(j, len(arr[i])), 0 - 50 * i)
			arr[i][j].X = calculate_x_pos(j, len(arr[i]))
			arr[i][j].Y = 0 - 50 * i
