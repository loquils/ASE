extends Control

var AmeliorationDarkMatter = preload("res://Design/Scenes/ButtonDarkMatter.tscn")
@onready var PanelValidationPrestige = $FondValidationPrestigePanel

# Called when the node enters the scene tree for the first time.
func _ready():
	for ameliorationDarkMatterInList in RessourceManager.ListeAmeliorationsDarkMatter:
		var newButtonAmeliorationDarkMatter = AmeliorationDarkMatter.instantiate()
		newButtonAmeliorationDarkMatter._set_var(ameliorationDarkMatterInList)
		$PresentationVBoxC/MarginC/VBoxC/PrestigeAmeliorationScrollC/PrestigeGridC.add_child(newButtonAmeliorationDarkMatter)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		$PresentationVBoxC/MarginC/VBoxC/Label.text = str(GetDeltaDarkMatter())


#Pour l'instant on utilise ça, c'est pas bien :3
func GetDeltaDarkMatter():
	if RessourceManager.HydrogeneMax.isLessThan(Big.new(1.0,5)):
		return Big.new(0.0)
		
	return Big.power(Big.subtractAbove0(RessourceManager.HydrogeneMax, Big.new(1.0,5)), 0.12)


#Trigger lors de l'appuie sur le bouton exit
func _on_button_exit_pressed():
	hide()

#Trigger lors de l'appuie sur le bouton de prestige, affiche la fenêtre de validation du prestige
func _on_prestige_button_pressed():
	PanelValidationPrestige.visible = true


#Trigger lors de l'appuie sur le bouton de validation du prestige
func _on_validation_prestige_button_pressed():
	DarkMatterReset()
	PanelValidationPrestige.hide()
	hide()


#Trigger lors de l'appuie sur le bouton d'annulation du prestige
func _on_annuler_prestige_button_pressed():
	PanelValidationPrestige.hide()


#Reset prestige, remet tout à zero, et ajoute la matière noire
func DarkMatterReset():
	RessourceManager.DarkMatter = Big.add(RessourceManager.DarkMatter, GetDeltaDarkMatter())
	RessourceManager.ResetAtomes()
	RessourceManager.ResetAmeliorationsHelium()
	RessourceManager.ResetRecherches()
	RessourceManager.ResetRessources()
