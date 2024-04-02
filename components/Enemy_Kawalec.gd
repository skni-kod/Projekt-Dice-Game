extends Sprite2D
var enemy_hp = 69: set = set_enemy_hp
var enemy_attack = 0
func _ready():
	$enemy_hp.value=enemy_hp
func set_enemy_hp(new_enemy_hp):
	enemy_hp=new_enemy_hp
	$enemy_hp_text.text = str(enemy_hp)
	$enemy_hp_text.show()
	$enemy_hp.value=enemy_hp
	
func Roll() -> void:
	enemy_hp=enemy_hp-5
	enemy_attack = randi_range(1,3)
	print(enemy_attack)
	match enemy_attack:
			1:  
				$Attack_text.text = "Kawalec szykuje atak"
				$Attack_text.show()
			2:
				$Attack_text.text = "Kawalec szykuje atak specjalny"
				$Attack_text.show()
			3:
				$Attack_text.text = "Kawalec czaruje"
				$Attack_text.show()

		

	
