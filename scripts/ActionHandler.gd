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
func HandleAction(act, stats:Stats):
	match act:
		Action.Attack:
			if GameManager.diceManager.Consume(stats.action_cost[act]):
				if GameManager.selected_enemy:
					GameManager.selected_enemy.stats.DealDamage(stats.damage)
		
		Action.AttackPlus:
			if GameManager.diceManager.Consume(stats.action_cost[act]):
				if GameManager.selected_enemy:
					GameManager.selected_enemy.stats.DealDamage(stats.damage_plus)
			
		Action.Defence:
			if GameManager.diceManager.Consume(stats.action_cost[act]):
				if GameManager.selected_enemy:
					GameManager.player.stats.AddArmor(stats.defence)
		Action.DefencePlus:
			if GameManager.diceManager.Consume(stats.action_cost[act]):
				if GameManager.selected_enemy:
					GameManager.player.stats.AddArmor(stats.defence_plus)
			
		Action.Special1:
			if GameManager.diceManager.Consume(stats.action_cost[act]):
				pass 
			
		Action.Special2:
			if GameManager.diceManager.Consume(stats.action_cost[act]):
				pass 
			
		Action.Special3:
			if GameManager.diceManager.Consume(stats.action_cost[act]):
				pass 
			
		Action.Special4:
			if GameManager.diceManager.Consume(stats.action_cost[act]):
				pass 

# Wywołanie akcji poprzez naciśnięcie odopowiedniego guzika.
func _on_button_press():
	HandleAction(action, GameManager.player.stats)

func _on_mouse_entered():
	$"../../ActionDescription".text = Action.keys()[action].replace("Plus","+")
	
func _on_mouse_exited():
	$"../../ActionDescription".text = ""
