extends Node
# Klasa odpowiedzialna za zarządzanie graczem.
class_name Player

var stats:Stats
var temporaryEffects : Array[TemporaryEffect]
@export var armor_slots : Array[ItemSlot]
@export var weapon_slots : Array[ItemSlot]

func _ready() -> void:
	stats = get_child(0) as Stats
	for i in armor_slots:
		i.item_inserted.connect(func (): _on_armor_inserted(i))
		i.item_removed.connect(func ():_on_armor_removed(i))
		
	for i in weapon_slots:
		i.item_inserted.connect(func ():_on_weapon_inserted(i))
		i.item_removed.connect(func ():_on_weapon_removed(i))

func DoActions():
	pass
	
func EndTurn():
	GameManager.EndPlayerTurn()

func _on_armor_inserted(slot : ItemSlot):
	var item = slot.item_inside
	
	if item.data1 == 0:
		stats.SetBaseMaxHealth(stats.base_max_health + item.data2)
	
	elif item.data1 == 1:
		stats.SetMaxHealthMult(stats.max_health_multiplier * item.data2)
	
func _on_armor_removed(slot : ItemSlot):
	var item = slot.item_inside
	
	if item.data1 == 0:
		stats.SetBaseMaxHealth(stats.base_max_health - item.data2)
	
	elif item.data1 == 1:
		stats.SetMaxHealthMult(stats.max_health_multiplier / item.data2)

func _on_weapon_inserted(slot : ItemSlot):
	var item = slot.item_inside
	
	if item.data1 == 0:
		stats.SetBaseDamage(stats.base_damage + item.data2)
	
	elif item.data1 == 1:
		stats.SetDamageMult(stats.damage_multiplier * item.data2)
	
func _on_weapon_removed(slot : ItemSlot):
	var item = slot.item_inside
	
	if item.data1 == 0:
		stats.SetBaseDamage(stats.base_damage - item.data2)
	
	elif item.data1 == 1:
		stats.SetDamageMult(stats.damage_multiplier / item.data2)
