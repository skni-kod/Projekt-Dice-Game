extends Node2D
var enemy_scene = preload("res://enemy_kawalec.tscn")
func _ready():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)

func przeciwnik_pokonany():
	pass

func _on_enemy_kawalec_kawalec_pokonany():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)



