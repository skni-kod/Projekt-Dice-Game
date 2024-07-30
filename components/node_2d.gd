extends Node2D

func _ready():
	var enemy_kawalec_scene = load("res://enemies/enemy_kawalec.tscn")
	var spawn_enemy_kawalec = enemy_kawalec_scene.instantiate()
	add_child(spawn_enemy_kawalec)

func Roll() -> void:
	get_tree().call_group("Enemies", "Roll")
