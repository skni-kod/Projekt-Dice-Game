extends Node
# Klasa odpowiedzialna za zarządzanie statystykami.
class_name Stats

@export var max_health_multiplier = 1.0
@export var base_max_health: int

@export var attack_multiplier = 1.0
@export var base_attack: int

@export var health: int
@export var armor: int

@export var health_display: TextureProgressBar
@export var armor_display: RichTextLabel

var max_health: int
var attack: int
var should_run_away: bool = false
var should_skip_turn: bool = false
var useful_attack_chance_mult: float = 1.0
var aggresive_attack_chance_mult: float = 1.0
var special_attack_chance_mult: float = 1.0

signal onDeath

func _ready():
	SetBaseMaxHealth(base_max_health)
	SetMaxHealthMult(max_health_multiplier)
	SetBaseAttack(base_attack)
	SetAttackMult(attack_multiplier)
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
	SetHealth(min(health+value,max_health))
	
func AddArmor(value):
	SetArmor(armor + value)
	
func SetHealth(value):
	health = min(value, max_health)
	_UpdateDisplays()
	
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
	
func SetBaseAttack(value):
	base_attack = value
	attack = attack_multiplier * base_attack
	_UpdateDisplays()

func SetAttackMult(value):
	attack_multiplier = value
	attack = attack_multiplier * base_attack
	_UpdateDisplays()

func _UpdateDisplays():
	if health_display: 
		health_display.max_value = max_health
		health_display.value = health
		if health_display.get_child_count() != 0:
			(health_display.get_child(0) as RichTextLabel).text = "[center] [b] " + str(health) + " / " + str(max_health)
	if armor_display: armor_display.text = str(armor)
