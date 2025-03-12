extends Node

#TODO trzeba jakoś połączyć mapę z main_scene

var diceManager: DiceManager
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
	enemy_waves.append(Wave.new(["goblin"]))
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
		for effect in enemy.temporaryEffects:
			effect.Apply(enemy.stats)
		
		enemy.temporaryEffects.reverse()
		for effect in enemy.temporaryEffects:
			if effect.HasExpired():
				effect.Expire(enemy.stats)
				enemy.temporaryEffects.erase(effect)
		enemy.temporaryEffects.reverse()
	
		enemy.DoActions()

func EndEnemyTurn(enemy : Enemy):
	enemies_turn_counter += 1
	if enemies_turn_counter < enemies.size():
		return
	
	for effect in player.temporaryEffects:
		effect.Apply(player.stats)
		
	player.temporaryEffects.reverse()
	for effect in player.temporaryEffects:
		if effect.HasExpired():
			effect.Expire(player.stats)
			player.temporaryEffects.erase(effect)
	player.temporaryEffects.reverse()
	
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
		
func Spawn(enemyName:String, waveSize: int, indexInWave: int):
	var enemy_prefab = load("res://prefabs/enemies/" + enemyName + ".tscn")
	var enemy_instance = enemy_prefab.instantiate()
	get_tree().root.get_child(1).add_child(enemy_instance)
	
	var enemy = enemy_instance as Enemy
	enemy._ready()
	enemy.stats.onDeath.connect(_on_enemy_die.bind(enemy))
	enemy.enemy_selected.connect(_on_enemy_selected)
	enemies.append(enemy)
	# TO DO: dodanie rozmieszczenia przeciwników
	# TYMCZASOWE
	var enemyRange: int = 700 / waveSize
	enemy_instance.position = Vector2(randf_range(-200 + enemyRange * indexInWave + 20, -200 + enemyRange + enemyRange * indexInWave - 40) ,randf_range(-20, 20))
	#Dodałem spawnowanie przeciwników na przedziale wysokości (-20, 20), żeby można było odróżnić paski życia, bo jest za ciasno dla kolegów golemów

func _on_enemy_selected(enemy: Enemy):
	selected_enemy = enemy

func _input(event):
	if event.is_action_pressed("ui_map"):
		if get_tree().root.get_node("Map"):
			return
			
		get_tree().root.add_child(preload("res://scenes/map.tscn").instantiate())
		(get_tree().root.get_child(get_tree().root.get_child_count() - 1) as Node2D).position = Vector2(-get_window().get_viewport().get_camera_2d().get_window().get_visible_rect().size.x/2 ,-get_window().get_viewport().get_camera_2d().get_window().get_visible_rect().size.y/2 )
	
	if event.is_action_pressed("close_ui_map"):
		if not get_tree().root.get_node("Map"):
			return
			
		get_tree().root.get_child(2).queue_free()
