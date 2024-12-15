extends Node

var diceManager: DiceManager
var player: Player
var enemy: Enemy
var spawner_licznik = 0

func _ready():
	Spawn("goblin")
	diceManager = get_node("/root/main_scene/Dices") as DiceManager
	player = get_node("/root/main_scene/Player") as Player
	player._ready()
	
func EndPlayerTurn():
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
	Spawn("goblin")
		
func Spawn(enemyName:String):
	var enemy_prefab = load("res://prefabs/enemies/" + enemyName + ".tscn")
	var enemy_instance = enemy_prefab.instantiate()
	get_node("/root/main_scene").add_child(enemy_instance)
	
	enemy = enemy_instance as Enemy
	enemy._ready()
	enemy.stats.onDeath.connect(_on_enemy_die)
