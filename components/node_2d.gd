extends Node2D
var enemy_hp;
func _ready():
	enemy_hp = 100;
	var enemy_goblin_scene = load("res://enemies/enemy_goblin.tscn")
	var spawn_enemy_goblin = enemy_goblin_scene.instantiate()
	add_child(spawn_enemy_goblin)
	$enemy_hp.value= enemy_hp
	$gracz_hp.value = Global.gracz_hp
	
	

func Roll() -> void:
	get_tree().call_group("Enemies", "Roll")
func harm(damage):
	enemy_hp=enemy_hp-damage;
	$enemy_hp.value=enemy_hp
	if(enemy_hp<=0):
		get_tree().call_group("Enemies", "Die")
func def(defence):
	Global.Tarcza=Global.Tarcza+defence;
	$"gracz_tarcza/gracz_tarcza_ilość".text = str(Global.Tarcza)
	
