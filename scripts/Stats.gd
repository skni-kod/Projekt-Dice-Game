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
	SetHealth(max_health)
	SetMaxHealth(max_health)
	SetArmor(initial_armor)
	
func DealDamage(value):
	if armor > value:
		SetArmor(armor - value)
	else:
		value -= armor
		SetArmor(0)
		SetHealth(max(health - value, 0))
	if health == 0:
		onDeath.emit()

func Heal(value):
	SetHealth(min(health+value,max_health))
	
func AddArmor(value):
	SetArmor(armor + value)
	
func SetHealth(value):
	health = min(value, max_health)
	_UpdateDisplays()
	
func SetArmor(value):
	armor = value
	_UpdateDisplays()
	
func SetMaxHealth(value):
	max_health = value
	_UpdateDisplays()
	
func _UpdateDisplays():
	if health_display: 
		health_display.max_value = max_health
		health_display.value = health
	if armor_display: armor_display.text = str(armor)
