extends Node

var enemy_hp;
var TestRzutu = 0;
var gracz_tarcza: int = 0: set = _set_gracz_tarcza
var gracz_hp: int = 100: set = _set_gracz_hp
var spawner_licznik = 0

func _ready():
	enemy_hp = 100;
	var enemy_goblin_scene = load("res://enemies/enemy_goblin.tscn")
	var spawn_enemy_goblin = enemy_goblin_scene.instantiate()
	var enemy_slime_scene = load("res://enemies/enemy_slime.tscn")
	var spawn_enemy_slime = enemy_slime_scene.instantiate()
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
		spawner()

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

##SPAWNER

func spawner():
		var enemy_slime_scene = load("res://enemies/enemy_slime.tscn")
		var spawn_enemy_slime = enemy_slime_scene.instantiate()
		var enemy_goblin_scene = load("res://enemies/enemy_goblin.tscn")
		var spawn_enemy_goblin = enemy_goblin_scene.instantiate()
		var parent = get_node("/root/main_scene")
		spawner_licznik=spawner_licznik+1;
		match spawner_licznik:
			1:  
				enemy_hp = 100;
				parent.add_child(spawn_enemy_slime)
			2:
				enemy_hp = 100;
				parent.add_child(spawn_enemy_goblin)
			3:
				enemy_hp = 100;
				parent.add_child(spawn_enemy_slime)
		var something4 = get_node("/root/main_scene/enemy_hp")
		something4.value=enemy_hp


