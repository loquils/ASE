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
	#Si on a pas de fichier de sauvgarde
	if not FileAccess.file_exists(SaveFilePath):
		return null

	# Récupère l'obj json
	var save_game = FileAccess.open(SaveFilePath, FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		var json = JSON.new()

		# Parse le Json
		var parse_result = json.parse(json_string)

		# Récupère les éléments du Json
		var ressourceLoadingGame = json.get_data()
		
		return ressourceLoadingGame


#Pour hard reset on écrit rien dans la sauvegarde et on quitte l'application
func hard_reset():
	if not FileAccess.file_exists(SaveFilePath):
		return null
	
	var save_game = FileAccess.open(SaveFilePath, FileAccess.WRITE)
	save_game.store_line("")
	
	get_tree().quit()
