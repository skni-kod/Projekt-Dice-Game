extends Sprite2D
var enemy_attack = 0
func _ready():
	add_to_group("Enemies")
	
func Roll() -> void:
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

		

	
