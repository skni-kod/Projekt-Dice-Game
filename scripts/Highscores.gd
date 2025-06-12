extends Node

# Called when the node enters the scene tree
func _ready() -> void:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))

	# Send a GET request
	var url = "http://localhost:3001/highscores"
	var error = http_request.request(url)
	
	if error != OK:
		self.text = "Failed to send request. Error code: %d" % error

# Signal handler for when the request is completed
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_text := body.get_string_from_utf8()

	var json_result = JSON.parse_string(response_text)
	self.text = "[b]Username[/b]\t\t[b]Score[/b]\t\t[b]Date[/b]\n"
	if json_result == null:
		self.text = "[color=red]Failed to parse JSON[/color]"
		return

	for i in json_result:
		var username = i.get("username", "Unknown")
		var score = i.get("score", 0)
		var timestamp = i.get("timestamp", 0)

		self.text += "%s\t\t\t%d\t\t%s\n" % [username, score,timestamp.substr(0,10)]
