extends Node

var diceManager: DiceManager
var player: Player
var enemy: Enemy
var spawner_licznik = 0
var enemy_wave: Wave

func _ready():
	enemy_wave = Wave.new()
	enemy_wave.create_wave(3)
	#Spawn("goblin")
	Spawn(String(enemy_wave.wave.pop_front()))
	#print("spaln golem :D")
	enemy_wave.remainingOpponents -= 1
	diceManager = get_node("/root/main_scene/Dices") as DiceManager
	player = get_node("/root/main_scene/Player") as Player
	player._ready()

func EndPlayerTurn():
	for effect in enemy.temporaryEffects:
		effect.Apply(enemy.stats)
		
	enemy.temporaryEffects.reverse()
	for effect in enemy.temporaryEffects:
		if effect.HasExpired():
			effect.Expire(enemy.stats)
			enemy.temporaryEffects.erase(effect)
	enemy.temporaryEffects.reverse()
	
	enemy.DoActions()

func EndEnemyTurn():
	for effect in player.temporaryEffects:
		effect.Apply(player.stats)
		
	player.temporaryEffects.reverse()
	for effect in player.temporaryEffects:
		if effect.HasExpired():
			effect.Expire(player.stats)
			player.temporaryEffects.erase(effect)
	player.temporaryEffects.reverse()
	
	player.DoActions()

func _on_enemy_die():
	enemy.queue_free()
	if(enemy_wave.remainingOpponents <= 0):
		enemy_wave.create_wave(3)
	Spawn(enemy_wave.wave.pop_front())
	enemy_wave.remainingOpponents -= 1
	#print(enemy_wave.remainingOpponents)
	#Spawn("goblin")
		
func Spawn(enemyName:String):
	var enemy_prefab = load("res://prefabs/enemies/" + enemyName + ".tscn")
	var enemy_instance = enemy_prefab.instantiate()
	get_node("/root/main_scene").add_child(enemy_instance)
	
	enemy = enemy_instance as Enemy
	enemy._ready()
	enemy.stats.onDeath.connect(_on_enemy_die)
