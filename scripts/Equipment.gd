extends Node

class_name Equipment

@export var items : Array[Item]

func AddItem(item : Item):
	items.append(item)
