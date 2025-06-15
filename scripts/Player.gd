extends Node
# Klasa odpowiedzialna za zarządzanie graczem.
class_name Player

@export var armor_slots : Array[ItemSlot]
@export var weapon_slots : Array[ItemSlot]

var stats: Stats
var effects: EffectArray

# Referencje do Area2D
@onready var character_area := $Character
@onready var backpack_ui := $Backpack
@onready var close_area := $Backpack/CloseButton

func _ready() -> void:
	# Ustawiamy startową widoczność
	character_area.visible = true
	backpack_ui.visible = false

	# Podłączamy input_event do obu Area2D
	character_area.connect("input_event", Callable(self, "_on_character_input_event"))
	close_area.connect("input_event", Callable(self, "_on_close_input_event"))

	# Inicjalizacja Stats i EffectArray
	for child in get_children():
		if child is Stats:
			stats = child as Stats
		elif child is EffectArray:
			effects = child as EffectArray

	# Podłączenie sygnałów slotów
	for i in armor_slots:
		i.item_inserted.connect(func (): _on_armor_inserted(i))
		i.item_removed.connect(func (): _on_armor_removed(i))

	for i in weapon_slots:
		i.item_inserted.connect(func (): _on_weapon_inserted(i))
		i.item_removed.connect(func (): _on_weapon_removed(i))

func DoActions():
	if stats.should_skip_turn:
		GameManager.EndPlayerTurn()

func EndTurn():
	GameManager.EndPlayerTurn()

# Obsługa kliknięcia na Character (Area2D)
func _on_character_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		character_area.visible = false
		backpack_ui.visible = true

# Obsługa kliknięcia na CloseButton (Area2D)
func _on_close_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		backpack_ui.visible = false
		character_area.visible = true

# Reszta funkcji bez zmian

func _on_armor_inserted(slot: ItemSlot):
	var item = slot.item_inside
	if item.data1 == 0:
		stats.SetBaseMaxHealth(stats.base_max_health + item.data2)
	elif item.data1 == 1:
		stats.SetMaxHealthMult(stats.max_health_multiplier * item.data2)

func _on_armor_removed(slot: ItemSlot):
	var item = slot.item_inside
	if item.data1 == 0:
		stats.SetBaseMaxHealth(stats.base_max_health - item.data2)
	elif item.data1 == 1:
		stats.SetMaxHealthMult(stats.max_health_multiplier / item.data2)

func _on_weapon_inserted(slot: ItemSlot):
	var item = slot.item_inside
	if item.data1 == 0:
		stats.SetBaseDamage(stats.base_damage + item.data2)
	elif item.data1 == 1:
		stats.SetDamageMult(stats.damage_multiplier * item.data2)

func _on_weapon_removed(slot: ItemSlot):
	var item = slot.item_inside
	if item.data1 == 0:
		stats.SetBaseDamage(stats.base_damage - item.data2)
	elif item.data1 == 1:
		stats.SetDamageMult(stats.damage_multiplier / item.data2)
