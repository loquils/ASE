extends Node

signal Research_button_pressed(recherche)

func RechercheButtonEventTrigger(recherche):
	Research_button_pressed.emit(recherche)
