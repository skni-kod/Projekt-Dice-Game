extends Node

func Spawner():
	var spawner_licznik = 0
	spawner_licznik =+ 1;
	var enemy_goblin_scene = load("res://enemies/enemy_goblin.tscn")
	var spawn_enemy_goblin = enemy_goblin_scene.instantiate()
	var parent = get_node("/root/main_scene")
	parent.add_child(spawn_enemy_goblin)
