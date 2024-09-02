extends Node

var TestRzutu = 0;
var gracz_tarcza: int = 0: set = _set_gracz_tarcza
var gracz_hp: int = 100: set = _set_gracz_hp

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

