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
				Global.harm(9)
		
		Action.AttackPlus:
			if Global.diceManager.ConsumeN(Dice.FaceType.Attack,3):
				Global.harm(20)	
			
		Action.Defence:
			pass 
		Action.DefencePlus:
			pass 
			
		Action.Special1:
			pass 
			
		Action.Special2:
			pass 
			
		Action.Special3:
			pass 
			
		Action.Special4:
			pass 

func _on_button_press():
	HandleAction(action)
	
