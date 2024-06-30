extends Control

@onready var LangueLabel = $PresentationVBoxC/MainMarginC/OptionsVBoxC/HBoxContainer/LangueLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		LangueLabel.text = LangueManager.languageCourrant


#Bouton pour hard_reset
func _on_force_reset_button_pressed():
	Save.hard_reset()


#Force une sauvegarde
func _on_button_save_pressed():
	Save.save_game()


#Appuie sur le bouton de fermeture du control
func _on_exit_button_pressed():
	hide()
