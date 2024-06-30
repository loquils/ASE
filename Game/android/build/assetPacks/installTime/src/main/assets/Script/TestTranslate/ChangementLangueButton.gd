extends Button

func _on_pressed():
	if(LangueManager.languageCourrant == "fr"):
		LangueManager.maj_langue("en")
	else:
		LangueManager.maj_langue("fr")
