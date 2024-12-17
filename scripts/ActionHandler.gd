extends Node
# Klasa zajmująca się przetwarzaniem akcji, które gracz może wykonać.
class_name ActionHandler

# Zbiór akcji dostępnych dla gracza.
enum Action
{
	Attack, AttackPlus, Defence, DefencePlus, Special1, Special2, Special3, Special4	
}

@export var action:Action

# Funkcja, przypisująca akcji pewne działanie.
func HandleAction(act):
	match act:
		Action.Attack:
			if GameManager.diceManager.ConsumeN(Dice.FaceType.Attack,2):
				GameManager.selected_enemy.stats.DealDamage(50)
		
		Action.AttackPlus:
			if GameManager.diceManager.ConsumeN(Dice.FaceType.Attack,3):
				GameManager.selected_enemy.stats.DealDamage(20)
			
		Action.Defence:
			if GameManager.diceManager.ConsumeN(Dice.FaceType.Defense,2):
				GameManager.player.stats.AddArmor(7)
		Action.DefencePlus:
			if GameManager.diceManager.ConsumeN(Dice.FaceType.Defense,3):
				GameManager.player.stats.AddArmor(15)
			
		Action.Special1:
			if GameManager.diceManager.ConsumeN(Dice.FaceType.Special,3):
				pass 
			
		Action.Special2:
			if GameManager.diceManager.ConsumeN(Dice.FaceType.Special,4):
				pass 
			
		Action.Special3:
			if GameManager.diceManager.ConsumeN(Dice.FaceType.Special,5):
				pass 
			
		Action.Special4:
			if GameManager.diceManager.ConsumeN(Dice.FaceType.Defense,6):
				pass 

# Wywołanie akcji poprzez naciśnięcie odopowiedniego guzika.
func _on_button_press():
	HandleAction(action)

func _on_mouse_entered():
	$"../ActionDescription".text = Action.keys()[action].replace("Plus","+")
	
func _on_mouse_exited():
	$"../ActionDescription".text = ""
