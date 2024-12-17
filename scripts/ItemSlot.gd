extends Area2D
# Klasa obsługująca zachowanie i dane slotu na item.
class_name ItemSlot


var item_inside : Item # Item wewnątrz slotu.
@export var acceptable_items : Array[Item.Type] # Przyjmowalne itemy.

func _ready() -> void:
	for child in get_children():
		if child is Item:
			PutItem(child as Item)
			break

# Funkcja do wsadzania itemu do slotu.
# Automatycznie zajmuje się wcześniejszym slotem itemu.
# Zwraca Prawda jeżeli udało się przenieść, i Fałsz w przeciwnym wypadku.
func PutItem(item: Item):
	if item and item.type not in acceptable_items:
		return false
		
	if item and item.current_slot:
		item.current_slot.item_inside = null
		item.current_slot.PutItem(item_inside)
		
	item_inside = item
	if item_inside:
		item_inside.get_parent().remove_child(item_inside)
		add_child(item_inside)
		item_inside.current_slot = self
		item_inside.transform.origin = Vector2(0,0)
	
	return true
