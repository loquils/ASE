extends Control

var BoutonRechercheDarkMatter = preload("res://Design/Scenes/Recherches/NewButtonRecherche.tscn")

@onready var PanelValidationPrestige = $FondValidationPrestigePanel
@onready var MatiereNoireQuantiteeLabel = $PresentationVBoxC/TopMarginC/TopHBoxC/BackGroundDarkMatter/MarginC/HBoxC/MatiereNoireLabel
@onready var MatierNoireApresPrestige = $PresentationVBoxC/MarginC/VBoxC/QuantiteeAGagnerHBoxC/QuantiteeLabel
@onready var RecherchesGridC = $PresentationVBoxC/MarginC/VBoxC/RecherchesMarginC/InterneRecherchesMarginC/PrestigeAmeliorationScrollC/PrestigeGridC
@onready var PrestigeButton = $PresentationVBoxC/MarginC/VBoxC/PrestigeButton
#Coefficient de calcul pour la matière noire
var CoefficientDivisionMatiereNoire = Big.new(1.3, 6)

#Initialize la vue de la matière noire
func _ready():
	#On connecte ici l'appuie du bouton lors de l'achat d'une recherche
	RechercheClick.connect("Research_button_pressed", AchatRehercheMatiereNoireButtonPressed)
	
	for rechercheDarkMatterInList in RessourceManager.ListeRecherchesMatiereNoire:
		var newButtonAmeliorationDarkMatter = BoutonRechercheDarkMatter.instantiate()
		newButtonAmeliorationDarkMatter._set_var(rechercheDarkMatterInList)
		RecherchesGridC.add_child(newButtonAmeliorationDarkMatter)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if RessourceManager.DarkMatter.isLessThan(Big.new(1.0)):
		PrestigeButton.disabled = true
	else:
		PrestigeButton.disabled = false
	
	if visible:
		MatiereNoireQuantiteeLabel.text = str(RessourceManager.DarkMatter)
		MatierNoireApresPrestige.text = str(GetDeltaDarkMatter())


#Nouveau test sur le calcul de la matière noire
func GetDeltaDarkMatterOld():
	var quantiteeMatiereNoire = Big.divide(InfosPartie.HydrogeneObtenuInThisReset, CoefficientDivisionMatiereNoire)
	return quantiteeMatiereNoire


#Nouveau test sur le calcul de la matière noire
func GetDeltaDarkMatter():
	var quantiteeMatiereNoire = Big.divide(InfosPartie.HydrogeneObtenuInThisReset, CoefficientDivisionMatiereNoire)
	var deltaMatiereNoire = Big.multiply(quantiteeMatiereNoire, Big.add(Big.new(1.0), BonusManager.GetDeltaDarkMatterBonus()))
	return deltaMatiereNoire


#Methode appellee par le signal lors de l'appuie sur un des boutons de recherches
#On vérifie si on peut acheter la recherche, et on l'achete.	
func AchatRehercheMatiereNoireButtonPressed(recherche):
	if recherche.ResearchLevel != Recherche.ResearchLevelEnum.DARKMATTER:
		return
	
	var IdRecherche = RessourceManager.ListeRecherchesMatiereNoire.find(recherche)
	
	if RessourceManager.ListeRecherchesMatiereNoire[IdRecherche].IsUnlocked:
		return
	
	if RessourceManager.ListeRecherchesMatiereNoire[IdRecherche].Prix.isGreaterThan(RessourceManager.DarkMatter):
		return
	
	RessourceManager.ListeRecherchesMatiereNoire[IdRecherche].IsUnlocked = true
	RessourceManager.DarkMatter = Big.subtractAbove0(RessourceManager.DarkMatter, RessourceManager.ListeRecherchesMatiereNoire[IdRecherche].Prix)
	
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
