extends Node

var diceManager: DiceManager
var playerStats: Stats
var enemy: Enemy
var spawner_licznik = 0

func _ready():
	spawner()
	playerStats = get_node("/root/main_scene/Player") as Stats
	diceManager = get_node("/root/main_scene/Dices") as DiceManager
	
	
func EndPlayerTurn():
	enemy.DoActions()

func EndEnemyTurn():
	pass

func _on_enemy_die():
	enemy.queue_free()
	spawner()
		
##SPAWNER
func spawner():
	var enemy_prefab = load("res://prefabs/enemies/goblin.tscn")
	var enemy_instance = enemy_prefab.instantiate()
	get_node("/root/main_scene").add_child(enemy_instance)
	
	enemy = enemy_instance as Enemy
	enemy._ready()
	enemy.stats.onDeath.connect(_on_enemy_die)
