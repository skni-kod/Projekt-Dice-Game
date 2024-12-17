extends Area2D
class_name Item

enum Type
{
	Potion, Weapon, Armor
}

var _is_mouse_over = false
var _slots_over: Array[ItemSlot]
var _is_dragged = false

var current_slot: ItemSlot
@export var type: Type

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
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Upuszczenie itemu.
			if _is_dragged and not event.pressed:
				if _slots_over.size() == 0:
					print("no slot")
					current_slot.PutItem(self)
				else:
					_slots_over[-1].PutItem(self)
				
			_is_dragged = event.pressed
	
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

#func SetSlot(slot : ItemSlot):
	#if slot.item_inside:
		#if not current_slot:
			#return
		#current_slot.PutItem(slot.item_inside)
		#
	#slot.PutItem(self)
