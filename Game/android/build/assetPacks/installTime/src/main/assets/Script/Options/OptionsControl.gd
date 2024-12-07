extends Control

@onready var ButtonFrancais = $MainPanelC/PresentationVBoxC/MainMarginC/OptionsVBoxC/LanguagePanelC/LanguageVBoxC/SelectionLangueMarginC/ButtonsHBoxC/FrancaisButton
@onready var ButtonAnglais = $MainPanelC/PresentationVBoxC/MainMarginC/OptionsVBoxC/LanguagePanelC/LanguageVBoxC/SelectionLangueMarginC/ButtonsHBoxC/EnglishButton
@onready var PanelResetValidation = $FondValidationResetPanel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match LangueManager.LanguageCourrant:
		"fr":
			ButtonFrancais.disabled = true
			ButtonAnglais.disabled = false
		"en":
			ButtonFrancais.disabled = false
			ButtonAnglais.disabled = true
		_:
			ButtonFrancais.disabled = true
			ButtonAnglais.disabled = true


func _on_language_button_pressed(buttonName):
	var langue = ""
	match buttonName:
		"Anglais":
			langue = "en"
		"Francais":
			langue = "fr"
		_:
			langue = "en"
	
	LangueManager.maj_langue(langue)

#Force une sauvegarde.
func _on_button_save_pressed():
	Save.save_game()


#Trigger lors de l'appuie sur le bouton du reset forcé, affiche la fenêtre de validation du reset.
func _on_force_reset_button_pressed():
	PanelResetValidation.visible = true


#Trigger lors de l'appuie sur le bouton de validation du reset.
func _on_validation_reset_button_pressed():
	PanelResetValidation.hide()
	hide()
	Save.hard_reset()


#Trigger lors de l'appuie sur le bouton d'annulation du reset.
func _on_annuler_reset_button_pressed():
	PanelResetValidation.hide()


#Appuie sur le bouton de fermeture des options.
func _on_exit_button_pressed():
	hide()


func _on_english_button_pressed():
	pass # Replace with function body.
