extends Node
# Klasa zajmująca się przetwarzaniem akcji, które gracz może wykonać.
class_name ActionHandler

func HandleAction(act:Action):
	if !GameManager.diceManager.Consume(act.cost):
		return
	
	for e in act.effects:
		if e.is_positive:
			GameManager.player.effects.AddTemporaryEffect(e)
			
		else:
			if act.isArea:
				for i in GameManager.enemies:
					i.effects.AddTemporaryEffect(e)
			elif GameManager.selected_enemy:
				GameManager.selected_enemy.effects.AddTemporaryEffect(e)

# Wywołanie akcji poprzez naciśnięcie odopowiedniego guzika.
func _on_button_press():
	var index = get_parent().get_children().find(self)
	if index < len(GameManager.player.actions):
		HandleAction(GameManager.player.actions[index])

func _on_mouse_entered():
	var index = get_parent().get_children().find(self)
	if index < len(GameManager.player.actions):
		$"../../ActionDescription".text = GameManager.player.actions[index].name
	
func _on_mouse_exited():
	$"../../ActionDescription".text = ""
