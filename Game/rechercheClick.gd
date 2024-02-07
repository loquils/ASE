extends Node

signal button_pressed(recherche)

func RechercheButtonEventTrigger(recherche):
	button_pressed.emit(recherche)
