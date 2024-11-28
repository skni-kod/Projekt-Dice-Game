extends Node

var diceManager: DiceManager
var playerStats: Stats
var enemyStats: Stats
var spawner_licznik = 0

func _ready():
	var enemy_goblin_scene = load("res://enemies/enemy_goblin.tscn")
	var spawn_enemy_goblin = enemy_goblin_scene.instantiate()
	var parent = get_node("/root/main_scene")
	parent.add_child(spawn_enemy_goblin)
	
	playerStats = get_node("/root/main_scene/Player") as Stats
	enemyStats = get_node("/root/main_scene/Enemy") as Stats
	diceManager = get_node("/root/main_scene/Dices") as DiceManager
	enemyStats.onDeath.connect(_on_enemy_die)

func _on_enemy_die():
	get_tree().call_group("Enemies", "Die")
	spawner()

##SPAWNER

func spawner():
		var enemy_goblin_scene = load("res://enemies/enemy_goblin.tscn")
		var spawn_enemy_goblin = enemy_goblin_scene.instantiate()
		var enemy_slime_scene = load("res://enemies/enemy_slime.tscn")
		var spawn_enemy_slime = enemy_slime_scene.instantiate()
		var parent = get_node("/root/main_scene")
		spawner_licznik = spawner_licznik + 1;
		match spawner_licznik:
			1:  
				enemyStats.Heal(100)
				parent.add_child(spawn_enemy_slime)
			2:
				enemyStats.Heal(100)
				parent.add_child(spawn_enemy_goblin)
			3:
				enemyStats.Heal(100)
				parent.add_child(spawn_enemy_slime)
