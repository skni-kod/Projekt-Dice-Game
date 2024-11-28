extends Sprite2D
var enemy_attack = 0
func _ready():
	add_to_group("Enemies")
	
func Roll() -> void:
	match enemy_attack:
			1:  
				Global.playerStats.DealDamage(5)
			2:
				Global.playerStats.DealDamage(10)
			3:
				pass
	enemy_attack = randi_range(1,3)
	print(enemy_attack)
	match enemy_attack:
			1:  
				$Attack_text.text = "goblin szykuje atak [img={50}x{50}]res://data/sprites/attack.png[/img]5"
				$Attack_text.show()
			2:
				$Attack_text.text = "goblin szykuje atak specjalny [img={50}x{50}]res://data/sprites/attack+.png[/img]10"
				$Attack_text.show()
			3:
				$Attack_text.text = "goblin potyka się o własne nogi [img={50}x{50}]res://data/sprites/dice_blank.png[/img]"
				$Attack_text.show()

func Die() -> void:
	queue_free()

	
