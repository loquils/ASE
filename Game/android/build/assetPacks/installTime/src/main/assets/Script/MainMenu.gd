extends Control

func _on_button_jouer_pressed():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		print(json_string)
	get_tree().change_scene_to_file("res://Game.tscn")
