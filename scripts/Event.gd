extends Level

class_name Event

func _init(n : int, pNodes : Array):
	levelNumber = n
	parentNodes = pNodes
	visible = true
	sprite = Sprite2D.new()
	sprite.texture = load("res://resources/sprites/MapEventIcon.png")
	add_child(sprite)
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = sprite.texture.get_size() if sprite.texture else Vector2(64, 64)
	collision_shape.shape = shape
	add_child(collision_shape)
