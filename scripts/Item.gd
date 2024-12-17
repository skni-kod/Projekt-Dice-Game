extends Area2D
# Klasa zajmująca się zachowaniem itemu.
class_name Item

# Typ itemu.
enum Type
{
	Potion, Weapon, Armor
}

var current_slot: ItemSlot # Aktualny slot w którym jest item.
@export var type: Type # Typ itemu.

# Wewnętrzne zmienne używane do przeciagania i ustawiania slotów.
var _is_mouse_over = false
var _slots_over: Array[ItemSlot]
var _is_dragged = false

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exit)
	
func _mouse_enter():
	_is_mouse_over = true	
	
func _mouse_exit():
	_is_mouse_over = false

func _input(event):
	if !_is_mouse_over and !_is_dragged:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# Upuszczenie itemu.
		if _is_dragged and not event.pressed:
			
			# Znajdź najbliższy slot nad którym jesteś,
			# może być null jeżeli nie jest nad żadnym.
			var closest_slot = _closest_slot()
			
			# Przenieś item na najbliższy slot,
			# lub wróć do swojego jeżeli nie ma najlbliższego lub cie nie przyjął.
			if closest_slot and closest_slot.PutItem(self):
				pass
			# a jeżeli nie to wraca do swojego slotu.
			else:
				transform.origin = Vector2(0,0)

		_is_dragged = event.pressed
	
	# Item jest przesówany.
	if _is_dragged and event is InputEventMouseMotion:
		position += event.relative
			
			
func _on_area_entered(area):
	if area is not ItemSlot:
		return
	_slots_over.append(area as ItemSlot)
		
func _on_area_exit(area):
	if area is not ItemSlot:
		return
		
	_slots_over.erase(area as ItemSlot)
	
func _closest_slot():
	if _slots_over.size() == 0:
		return null
		
	var closest = _slots_over[-1]
	var min_dist = get_global_mouse_position().distance_squared_to(closest.global_position)
	for i in _slots_over:
		if i != closest:
			var d = get_global_mouse_position().distance_squared_to(closest.global_position)
			if d < min_dist:
				min_dist = d
				closest = i
				
	return closest
