class_name Dice
extends TextureButton

enum FaceType
{
	Blank = 0, Attack, Defense, Special, Last = Special
}

var manager
var currentFace = FaceType.Blank
var mouse_pressed = false
var mouse_over = false

func _ready()->void:
	set_process_input(true)
	mouse_entered.connect(self._on_mouse_entered)
	mouse_exited.connect(self._on_mouse_exit)
	currentFace = FaceType.Blank
	manager = get_parent() as DiceManager
	UpdateDisplay()

func _input(event):	
	if event is InputEventMouseButton:
		mouse_pressed = event.is_pressed()
		if mouse_pressed and mouse_over:
			if button_pressed:
				Deselect()
			else: 
				Select()
				
		if !mouse_pressed:
			texture_normal = load("res://data/sprites/dice_blank.png")
			

func _on_mouse_entered():
	mouse_over = true
	if mouse_pressed:
		if button_pressed:
			Deselect()
		else: 
			Select()
		
func _on_mouse_exit():
	mouse_over = false
	texture_normal = load("res://data/sprites/dice_blank.png")
	
func _button_pressed():
	if currentFace == FaceType.Blank:
		button_pressed = false
		
func Select():
	if currentFace != FaceType.Blank and manager.SelectedDiceCount() < manager.current_max_selected_dices:
		button_pressed = true
	else:
		texture_normal = load("res://data/sprites/dice_blank_selection_discarded.png")
	
func Deselect():
	button_pressed = false
		
func Randomize(rng:RandomNumberGenerator) -> void:
	currentFace = rng.randi_range(1, FaceType.Last) as FaceType
	UpdateDisplay()

func UpdateDisplay() -> void:
	if currentFace == FaceType.Blank:
		get_child(0).texture = null
	else:
		get_child(0).texture = load("res://data/sprites/" + FaceType.keys()[currentFace].to_lower() +".png")
