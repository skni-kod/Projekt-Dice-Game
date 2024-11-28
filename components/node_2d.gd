extends Node2D
var enemy_hp;


func Roll() -> void:
	get_tree().call_group("Enemies", "Roll")

func def(defence):
	Global.gracz_tarcza=Global.gracz_tarcza+defence;
	$"gracz_tarcza/gracz_tarcza_ilość".text = str(Global.gracz_tarcza)
