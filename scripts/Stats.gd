extends Node
class_name Stats

@export var max_health: int
@export var initial_armor: int
@export var health_display: ProgressBar
@export var armor_display: RichTextLabel
var health: int
var armor: int
signal onDeath


func _ready():
	health = max_health
	armor = initial_armor
	_UpdateDisplays()
	
func DealDamage(value):
	if armor > value:
		armor = armor - value
	else:
		value = value - armor
		armor = 0
		health = max(health - value, 0)
	_UpdateDisplays()
	if health == 0:
		onDeath.emit()

func Heal(value):
	health = min(health+value,max_health)
	_UpdateDisplays()
	
	
func AddArmor(value):
	armor = armor + value
	_UpdateDisplays()
	
func _UpdateDisplays():
	if health_display: 
		health_display.max_value = max_health
		health_display.value = health
	if armor_display: armor_display.text = str(armor)
