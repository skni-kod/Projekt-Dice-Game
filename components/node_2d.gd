extends Node2D
var enemy_hp;
func _ready():
	enemy_hp = 69;
	var enemy_kawalec_scene = load("res://enemies/enemy_kawalec.tscn")
	var spawn_enemy_kawalec = enemy_kawalec_scene.instantiate()
	add_child(spawn_enemy_kawalec)
	$enemy_hp.value=enemy_hp

func Roll() -> void:
	get_tree().call_group("Enemies", "Roll")
func harm(damage):
	enemy_hp=enemy_hp-damage;
	$enemy_hp.value=enemy_hp
	if(enemy_hp<=0):
		get_tree().call_group("Enemies", "Die")
func def(defence):
	Global.Tarcza=Global.Tarcza+defence;
	$gracz_tarcza.text = str(Global.Tarcza)
	
