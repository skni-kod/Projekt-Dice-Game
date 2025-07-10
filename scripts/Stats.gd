extends Node
# Klasa odpowiedzialna za zarządzanie statystykami.
class_name Stats

@export var max_health_multiplier = 1.0
@export var base_max_health: int

@export var defence_multiplier = 1.0
@export var base_defence: int

@export var defence_plus_multiplier = 1.0
@export var base_plus_defence: int

@export var damage_multiplier = 1.0
@export var base_damage: int

@export var damage_plus_multiplier = 1.0
@export var base_damage_plus: int

@export var health: int
@export var armor: int

@export var health_display: TextureProgressBar
@export var armor_display: RichTextLabel

var max_health: int
var defence:int
var defence_plus:int
var damage: int
var damage_plus: int
var should_run_away: bool = false
var should_skip_turn: bool = false
var useful_damage_chance_mult: float = 1.0
var aggresive_damage_chance_mult: float = 1.0
var special_damage_chance_mult: float = 1.0
var action_cost = {
	ActionHandler.Action.Attack:[Dice.FaceType.Attack],
	ActionHandler.Action.AttackPlus:[Dice.FaceType.Attack,Dice.FaceType.Attack],
	ActionHandler.Action.Defence:[Dice.FaceType.Defense],
	ActionHandler.Action.DefencePlus:[Dice.FaceType.Defense,Dice.FaceType.Defense],
	ActionHandler.Action.Special1:[Dice.FaceType.Special],
	ActionHandler.Action.Special2:[Dice.FaceType.Special],
	ActionHandler.Action.Special3:[Dice.FaceType.Special],
	ActionHandler.Action.Special4:[Dice.FaceType.Special],
}

signal onDeath

func _ready():
	SetBaseMaxHealth(base_max_health)
	SetMaxHealthMult(max_health_multiplier)
	SetBaseDefence(base_defence)
	SetDefenceMult(defence_multiplier)
	SetBasePlusDefence(base_plus_defence)
	SetDefencePlusMult(defence_plus_multiplier)
	SetBaseDamage(base_damage)
	SetDamageMult(damage_multiplier)
	SetBaseDamagePlus(base_damage_plus)
	SetDamagePlusMult(damage_plus_multiplier)
	SetArmor(armor)
	SetHealth(health)
	
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
	SetHealth(min(health + value, max_health))
	
func AddArmor(value):
	SetArmor(armor + value)
	
func SetHealth(value):
	# Aktualizacja wartości zdrowia
	health = min(value, max_health)
	_UpdateDisplays()

	# Wywołanie funkcji w skrypcie nadrzędnym (Enemy.gd), jeśli istnieje
	var parent = get_parent()
	if parent and parent.has_method("OnHealthChanged"):
		parent.call("OnHealthChanged", health, max_health)
	
func SetArmor(value):
	armor = value
	_UpdateDisplays()
	
func SetBaseMaxHealth(value):
	base_max_health = value
	max_health = max_health_multiplier * base_max_health
	health = min(health, max_health)
	_UpdateDisplays()

func SetMaxHealthMult(value):
	max_health_multiplier = value
	max_health = max_health_multiplier * base_max_health
	health = min(health, max_health)
	_UpdateDisplays()
	
func SetBaseDefence(value):
	base_defence = value
	defence = defence_multiplier * base_defence
	_UpdateDisplays()

func SetDefenceMult(value):
	defence_multiplier = value
	defence = defence_multiplier * base_defence
	_UpdateDisplays()
	
func SetBasePlusDefence(value):
	base_plus_defence = value
	defence_plus = defence_plus_multiplier * base_plus_defence
	_UpdateDisplays()

func SetDefencePlusMult(value):
	defence_plus_multiplier = value
	defence_plus = defence_plus_multiplier * base_plus_defence
	_UpdateDisplays()
	
func SetBaseDamage(value):
	base_damage = value
	damage = damage_multiplier * base_damage
	_UpdateDisplays()

func SetDamageMult(value):
	damage_multiplier = value
	damage = damage_multiplier * base_damage
	_UpdateDisplays()
	
func SetBaseDamagePlus(value):
	base_damage_plus = value
	damage_plus = damage_plus_multiplier * base_damage_plus
	_UpdateDisplays()

func SetDamagePlusMult(value):
	damage_plus_multiplier = value
	damage_plus = damage_plus_multiplier * base_damage_plus
	_UpdateDisplays()

func _UpdateDisplays():
	if health_display: 
		health_display.max_value = max_health
		health_display.value = health
		if health_display.get_child_count() != 0:
			(health_display.get_child(0) as RichTextLabel).text = "[center] [b] " + str(health) + " / " + str(max_health)
	if armor_display:
		armor_display.text = str(armor)
