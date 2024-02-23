extends Node

var SaveFilePath = "user://savegame.save"

func save_game():
	var save_game = FileAccess.open(SaveFilePath, FileAccess.WRITE)
	var RessourceNodeToSave = RessourceManager
	
	# Call the node's save function.
	var node_data = RessourceNodeToSave.call("save")

	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(node_data)

	# Store the save dictionary as a new line in the save file.
	save_game.store_line(json_string)


func load_game():
	if not FileAccess.file_exists(SaveFilePath):
		return null# Error! We don't have a save to load.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_game = FileAccess.open(SaveFilePath, FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()

		return node_data
