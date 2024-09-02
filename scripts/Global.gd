extends Node

var TestRzutu = 0;
var Tarcza = 0;
var gracz_hp: int = 100: set = _set_gracz_hp

func _set_gracz_hp(new_value : int):
		gracz_hp = new_value
		print(gracz_hp)
		var progress_bar = get_node("/root/main_scene/gracz_hp")
		progress_bar.value = gracz_hp
