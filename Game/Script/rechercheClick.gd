extends Node

signal Research_button_pressed(recherche)
signal Attribut_button_pressed(atome)
signal UnlockAtome_button_pressed(atome)
signal AmeliorationHelium_button_pressed(ameliorationHelium)
signal AmeliorationLithium_button_pressed(ameliorationLithium)
signal RechercheDarkMatter_button_pressed(ameliorationDarkMatter)

#Appuie sur un bouton de recherche.
func RechercheButtonEventTrigger(recherche):
	Research_button_pressed.emit(recherche)


#Appuie sur un bouton d'augmentation d'attribut.
func AttributButtonEventTrigger(attribut):
	Attribut_button_pressed.emit(attribut)


#Appuie sur un bouton pour débloquer un atome.
func UnlockAtomeButtonEventTrigger(atome):
	UnlockAtome_button_pressed.emit(atome)


#Appuie sur un bouton d'amélioration Helium.
func AmeliorationHeliumButtonEventTrigger(ameliorationHelium):
	AmeliorationHelium_button_pressed.emit(ameliorationHelium)


#Appuie sur un bouton d'amélioration Lithium.
func AmeliorationLithiumButtonEventTrigger(ameliorationLithium):
	AmeliorationLithium_button_pressed.emit(ameliorationLithium)


#Appuie sur un bouton de recherche de matière noire.
func RechercheDarkMatterButtonEventTrigger(rechercheDarkMatter):
	RechercheDarkMatter_button_pressed.emit(rechercheDarkMatter)
