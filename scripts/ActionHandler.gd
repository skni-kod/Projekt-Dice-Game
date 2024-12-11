extends Node

enum Action
{
	Attack, AttackPlus, Defence, DefencePlus, Special1, Special2, Special3, Special4	
}

@export var action:Action

	
func HandleAction(act):
	match act:
		Action.Attack:
			if Global.diceManager.ConsumeN(Dice.FaceType.Attack,2):
				Global.enemy.stats.DealDamage(50)
		
		Action.AttackPlus:
			if Global.diceManager.ConsumeN(Dice.FaceType.Attack,3):
				Global.enemy.stats.DealDamage(20)
			
		Action.Defence:
			if Global.diceManager.ConsumeN(Dice.FaceType.Defense,2):
				Global.playerStats.AddArmor(7)
		Action.DefencePlus:
			if Global.diceManager.ConsumeN(Dice.FaceType.Defense,3):
				Global.playerStats.AddArmor(15)
			
		Action.Special1:
			if Global.diceManager.ConsumeN(Dice.FaceType.Special,3):
				pass 
			
		Action.Special2:
			if Global.diceManager.ConsumeN(Dice.FaceType.Special,4):
				pass 
			
		Action.Special3:
			if Global.diceManager.ConsumeN(Dice.FaceType.Special,5):
				pass 
			
		Action.Special4:
			if Global.diceManager.ConsumeN(Dice.FaceType.Defense,6):
				pass 

func _on_button_press():
	HandleAction(action)
	
func _on_mouse_entered():
	$"../ActionDescription".text = Action.keys()[action].replace("Plus","+")
	
func _on_mouse_exited():
	$"../ActionDescription".text = ""
