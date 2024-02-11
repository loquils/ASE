extends Node

signal Research_button_pressed(recherche)
signal Attribut_button_pressed(atome)
signal UnlockAtome_button_pressed(atome)

func RechercheButtonEventTrigger(recherche):
	Research_button_pressed.emit(recherche)

func AttributButtonEventTrigger(attribut):
	Attribut_button_pressed.emit(attribut)

func UnlockAtomeButtonEventTrigger(atome):
	UnlockAtome_button_pressed.emit(atome)
