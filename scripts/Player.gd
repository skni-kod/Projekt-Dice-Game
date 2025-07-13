extends Node
# Klasa odpowiedzialna za zarządzanie graczem.
class_name Player

@export var armor_slots : Array[ItemSlot]
@export var weapon_slots : Array[ItemSlot]
@export var default_actions : Array[Action]

var stats: Stats
var effects: EffectArray
var actions : Array[Action]

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
	actions = default_actions
	for child in get_children():
		if child is Stats:
			stats = child as Stats
		elif child is EffectArray:
			effects = child as EffectArray
	effects.stats = stats

	# Podłączenie sygnałów slotów
	for i in armor_slots:
		i.item_inserted.connect(_on_armor_inserted.bind(i))
		i.item_removed.connect(_on_armor_removed.bind(i))

	for i in weapon_slots:
		i.item_inserted.connect(_on_weapon_inserted.bind(i))
		i.item_removed.connect(_on_weapon_removed.bind(i))

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
	for effect in item.effects:
		effect._ApplyEffect(stats)


func _on_armor_removed(slot: ItemSlot):
	var item = slot.item_inside
	for effect in item.effects:
		effect._RevertEffect(stats)


func _on_weapon_inserted(slot: ItemSlot):
	var item = slot.item_inside as Weapon
	
	for i in range(len(item.actions)):
		actions[i] = item.actions[i]

	for effect in item.effects:
		effect._ApplyEffect(stats)


func _on_weapon_removed(slot: ItemSlot):
	var item = slot.item_inside
	actions = default_actions
	for effect in item.effects:
		effect._RevertEffect(stats)
