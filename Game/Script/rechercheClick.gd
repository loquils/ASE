extends Node

signal Research_button_pressed(recherche)
signal Attribut_button_pressed(atome)
signal UnlockAtome_button_pressed(atome)

#Appuie sur un bouton de recherche.
func RechercheButtonEventTrigger(recherche):
	Research_button_pressed.emit(recherche)

#Appuie sur un bouton d'augmentation d'attribut.
func AttributButtonEventTrigger(attribut):
	Attribut_button_pressed.emit(attribut)

#Appuie sur un bouton pour débloquer un atome.
func UnlockAtomeButtonEventTrigger(atome):
	UnlockAtome_button_pressed.emit(atome)
