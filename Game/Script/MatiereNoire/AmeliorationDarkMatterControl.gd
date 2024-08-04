extends Control

var BoutonRechercheDarkMatter = preload("res://Design/Scenes/ButtonDarkMatter.tscn")
@onready var PanelValidationPrestige = $FondValidationPrestigePanel
@onready var MatiereNoireQuantiteeLabel = $PresentationVBoxC/TopMarginC/TopHBoxC/BackGroundDarkMatter/MarginC/HBoxC/MatiereNoireLabel
@onready var MatierNoireApresPrestige = $PresentationVBoxC/MarginC/VBoxC/QuantiteeAGagnerHBoxC/QuantiteeLabel
@onready var RecherchesGridC = $PresentationVBoxC/MarginC/VBoxC/RecherchesMarginC/InterneRecherchesMarginC/PrestigeAmeliorationScrollC/PrestigeGridC

#Coefficient de calcul pour la matière noire
var CoefficientDivisionMatiereNoire = Big.new(5.0,6)

# Called when the node enters the scene tree for the first time.
func _ready():
	#On connecte ici l'appuie du bouton lors de l'achat d'une recherche
	RechercheClick.connect("RechercheDarkMatter_button_pressed", AchatRehercheMatiereNoireButtonPressed)
	
	for rechercheDarkMatterInList in RessourceManager.ListeRecherchesMatiereNoire:
		var newButtonAmeliorationDarkMatter = BoutonRechercheDarkMatter.instantiate()
		newButtonAmeliorationDarkMatter._set_var(rechercheDarkMatterInList)
		RecherchesGridC.add_child(newButtonAmeliorationDarkMatter)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		MatiereNoireQuantiteeLabel.text = str(RessourceManager.DarkMatter)
		MatierNoireApresPrestige.text = str(GetDeltaDarkMatter())


#Pour l'instant on utilise ça, c'est pas bien :3, faut changer l'hydrogène max
func GetDeltaDarkMatterOld():
	if InfosPartie.HydrogeneMaximum.isLessThan(Big.new(1.0,5)):
		return Big.new(0.0)
		
	return Big.power(Big.subtractAbove0(InfosPartie.HydrogeneMaximum, Big.new(1.0,5)), 0.5)


#Nouveau test sur le calcul de la matière noire
func GetDeltaDarkMatter():
	var quantiteeMatiereNoire = Big.divide(InfosPartie.HydrogeneMaximum, CoefficientDivisionMatiereNoire)
	return quantiteeMatiereNoire


#Methode appellee par le signal lors de l'appuie sur un des boutons de recherches
#On vérifie si on peut acheter la recherche, et on l'achete.	
func AchatRehercheMatiereNoireButtonPressed(recherche):
	if RessourceManager.ListeRecherchesMatiereNoire[recherche.Id].IsUnlocked:
		return
	
	if RessourceManager.ListeRecherchesMatiereNoire[recherche.Id].Prix.isGreaterThan(RessourceManager.DarkMatter):
		return
	
	RessourceManager.ListeRecherchesMatiereNoire[recherche.Id].IsUnlocked = true
	RessourceManager.DarkMatter = Big.subtractAbove0(RessourceManager.DarkMatter, RessourceManager.ListeRecherchesMatiereNoire[recherche.Id].Prix)

	BonusManager.MajBonusRecherchesMatiereNoire()


#Reset prestige, remet tout à zero, et ajoute la matière noire
func DarkMatterReset():
	RessourceManager.DarkMatter = Big.add(RessourceManager.DarkMatter, GetDeltaDarkMatter())
	RessourceManager.ResetAtomes()
	RessourceManager.ResetAmeliorationsHelium()
	RessourceManager.ResetAmeliorationsLithium()
	RessourceManager.ResetRecherches()
	InfosPartie.ResetInformationsOnPrestige()
	RessourceManager.ResetRessources()


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
