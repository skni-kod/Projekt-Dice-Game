extends Node
	
# TO DO: zaznaczanie przeciwników

var diceManager: DiceManager
var player: Player
var enemies: Array[Enemy]
var selected_enemy : Enemy = null
var enemy_waves: Array[Wave]
var current_wave = 0
var enemies_turn_counter = 0

func _ready():
	enemy_waves.append(Wave.new(["goblin", "goblin", "goblin"]))
	enemy_waves.append(Wave.new(["goblin","goblin", "goblin", "goblin"]))
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
		current_wave = (current_wave + 1) % enemy_waves.size()
		SpawnWave(enemy_waves[current_wave]);
	else:
		selected_enemy = enemies[0]

func SpawnWave(wave:Wave):
	enemies.clear()
	var indexInWave: int = 0
	for enemy in wave.enemies:
		Spawn(enemy, wave.enemies.size(), indexInWave)
		indexInWave += 1
	selected_enemy = enemies[0]
		
func Spawn(enemyName:String, waveSize: int, indexInWave: int):
	var enemy_prefab = load("res://prefabs/enemies/" + enemyName + ".tscn")
	var enemy_instance = enemy_prefab.instantiate()
	get_node("/root/main_scene").add_child(enemy_instance)
	
	var enemy = enemy_instance as Enemy
	enemy._ready()
	enemy.stats.onDeath.connect(_on_enemy_die.bind(enemy))
	enemies.append(enemy)
	
	# TO DO: dodanie rozmieszczenia przeciwników
	# TYMCZASOWE
	var range: int = 700 / waveSize
	enemy_instance.position = Vector2(randf_range(-200 + range * indexInWave, -200 + range + range * indexInWave) ,randf_range(-20, 20))
	#Dodałem spawnowanie przeciwników na przedziale wysokości (-20, 20), żeby można było odróżnić paski życia, bo jest za ciasno dla kolegów golemów
