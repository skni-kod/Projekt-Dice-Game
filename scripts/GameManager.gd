extends Node

var diceManager: DiceManager
var map_scene := preload("res://scenes/map.tscn")
var map_instance: Node2D = null
var player: Player
var enemies: Array[Enemy]
var selected_enemy : Enemy = null
var enemy_waves: Array[Wave]
var current_wave = 0
var enemies_turn_counter = 0
var current_level : Level = null
var level
var rng = RandomNumberGenerator.new()

func _ready():
	enemy_waves.append(Wave.new(["goblin","goblin"]))
	#for potwor in enemy_waves[1].enemies:
		#print(potwor)
	SpawnWave(enemy_waves[current_wave])
	diceManager = get_node("/root/main_scene/Dices") as DiceManager
	player = get_node("/root/main_scene/Player") as Player
	player._ready()

func EndPlayerTurn():
	enemies_turn_counter = 0
	for enemy in enemies:
		enemy.effects.UpdateEffects(enemy.stats)
	
		enemy.DoActions()

func EndEnemyTurn(enemy : Enemy):
	enemies_turn_counter += 1
	if enemies_turn_counter < enemies.size():
		return
	
	player.effects.UpdateEffects(player.stats)
	player.DoActions()

func _on_enemy_die(enemy:Enemy):
	if enemy == selected_enemy:
		selected_enemy = null
	enemy.queue_free()
	enemies.erase(enemy)
	if enemies.size() == 0:
		current_wave += 1
		if current_wave < enemy_waves.size():
			SpawnWave(enemy_waves[current_wave]);
	else:
		selected_enemy = enemies[0]
		selected_enemy.set_as_current_enemy()

func SpawnWave(wave:Wave):
	enemies.clear()
	var indexInWave: int = 0
	for enemy in wave.enemies:
		Spawn(enemy, wave.enemies.size(), indexInWave)
		indexInWave += 1
	selected_enemy = enemies[0]
	selected_enemy.set_as_current_enemy()
		
func Spawn(enemyName: String, waveSize: int, indexInWave: int):
	var enemy_prefab = load("res://prefabs/enemies/" + enemyName + ".tscn")
	var enemy_instance = enemy_prefab.instantiate()
	get_tree().root.get_child(1).add_child(enemy_instance)

	var enemy = enemy_instance as Enemy
	enemy._ready()
	enemy.stats.onDeath.connect(_on_enemy_die.bind(enemy))
	enemy.enemy_selected.connect(_on_enemy_selected)
	enemies.append(enemy)

	# Rozstaw przeciwników co ~80 jednostek, centrowany względem środka
	var spacing := 80
	var total_width := (waveSize - 1) * spacing
	var base_x := -total_width / 2 + indexInWave * spacing + 50
	var x_offset := randf_range(-5, 5)  # mały random dla różnorodności
	var y_offset := randf_range(-5, 5)

	enemy_instance.position = Vector2(
		base_x + x_offset,
		y_offset
	)



func _on_enemy_selected(enemy: Enemy):
	selected_enemy = enemy

func _input(event):
	if event.is_action_pressed("ui_map"):
		if map_instance == null:
			map_instance = map_scene.instantiate()
			map_instance.name = "Map"
			map_instance.z_index = 100
			map_instance.position = -get_window().get_viewport().get_camera_2d().get_window().get_visible_rect().size / 2
			get_tree().root.add_child(map_instance)
		else:
			map_instance.visible = true

	if event.is_action_pressed("close_ui_map"):
		if map_instance != null:
			map_instance.visible = false
