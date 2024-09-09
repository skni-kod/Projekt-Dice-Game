extends Node

var enemy_hp;
var TestRzutu = 0;
var gracz_tarcza: int = 0: set = _set_gracz_tarcza
var gracz_hp: int = 100: set = _set_gracz_hp

func _ready():
	enemy_hp = 100;
	var enemy_goblin_scene = load("res://enemies/enemy_goblin.tscn")
	var spawn_enemy_goblin = enemy_goblin_scene.instantiate()
	var parent = get_node("/root/main_scene")
	parent.add_child(spawn_enemy_goblin)
	var something1 = get_node("/root/main_scene/enemy_hp")
	something1.value = enemy_hp
	var something2 = get_node("/root/main_scene/gracz_hp")
	something2.value = gracz_hp

func harm(damage):
	enemy_hp=enemy_hp-damage;
	var something1 = get_node("/root/main_scene/enemy_hp")
	something1.value=enemy_hp
	if(enemy_hp<=0):
		get_tree().call_group("Enemies", "Die")

func _set_gracz_tarcza(zmiana : int):
		gracz_tarcza = zmiana
		if(gracz_tarcza<0):
			gracz_hp = gracz_hp+(gracz_tarcza);
			gracz_tarcza=0;
		elif(gracz_tarcza==0):
			print("Tarcza ded")
		var something = get_node("/root/main_scene/gracz_tarcza/gracz_tarcza_ilość")
		something.text = str(gracz_tarcza)


func _set_gracz_hp(new_value : int):
		gracz_hp = new_value
		print(gracz_hp)
		var progress_bar = get_node("/root/main_scene/gracz_hp")
		progress_bar.value = gracz_hp

