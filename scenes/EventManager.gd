extends Control

@onready var title_label = $TextureRect/Title_label
@onready var desc_label = $TextureRect/Description_label
@onready var choices_container = $TextureRect/Choices_Container

var choices: Array = []

func _ready():
	randomize()
	load_random_data("res://events.json")

func load_random_data(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file:
		var json_text := file.get_as_text()
		var data = JSON.parse_string(json_text)

		if typeof(data) == TYPE_ARRAY and data.size() > 0:
			var random_event = data[randi_range(0, data.size() - 1)]
			title_label.text = random_event.get("title", "Brak tytułu")
			desc_label.text = random_event.get("description", "Brak opisu")

			choices.clear()
			for child in choices_container.get_children():
				child.queue_free()
			for option in random_event.get("options", []):
				var choice = EventChoice.new(
					option.get("text", ""),
					option.get("output", ""),
					option.get("effect", {})
				)
				choices.append(choice)
				
				var btn = Button.new()
				btn.text = choice.text
				btn.connect("pressed", Callable(self, "_on_choice_selected").bind(choice))
				choices_container.add_child(btn)
				

			for choice in choices:
				print(choice.text)
				print(choice.output)
				print(choice.effects)
		else:
			push_error("Niepoprawny format JSON lub pusta lista")
	else:
		push_error("Nie można otworzyć pliku: " + path)

func _on_choice_selected(choice: EventChoice) -> void:
	print("Wybrano opcję:", choice.text)
	print("Efekt:", choice.effects)
	print("Output:", choice.output)

	#todo
	desc_label.text = choice.output
