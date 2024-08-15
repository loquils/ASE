extends Control

@onready var LangueLabel = $PresentationVBoxC/MainMarginC/OptionsVBoxC/HBoxContainer/LangueLabel
@onready var PanelResetValidation = $FondValidationResetPanel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		LangueLabel.text = LangueManager.languageCourrant


#Force une sauvegarde
func _on_button_save_pressed():
	Save.save_game()


#Appuie sur le bouton de fermeture du control
func _on_exit_button_pressed():
	hide()


	#Trigger lors de l'appuie sur le bouton de prestige, affiche la fenêtre de validation du prestige
func _on_force_reset_button_pressed():
	PanelResetValidation.visible = true


#Trigger lors de l'appuie sur le bouton de validation du prestige
func _on_validation_reset_button_pressed():
	PanelResetValidation.hide()
	hide()
	Save.hard_reset()


#Trigger lors de l'appuie sur le bouton d'annulation du prestige
func _on_annuler_reset_button_pressed():
	PanelResetValidation.hide()
