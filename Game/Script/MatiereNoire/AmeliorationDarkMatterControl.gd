extends Control

var BoutonRechercheDarkMatter = preload("res://Design/Scenes/Recherches/NewButtonRecherche.tscn")

@onready var PanelValidationPrestige = $FondValidationPrestigePanel
@onready var MatiereNoireQuantiteeLabel = $PresentationVBoxC/TopMarginC/TopHBoxC/BackGroundDarkMatter/MarginC/HBoxC/MatiereNoireLabel
@onready var MatierNoireApresPrestige = $PresentationVBoxC/MarginC/VBoxC/QuantiteeAGagnerHBoxC/QuantiteeLabel
@onready var RecherchesGridC = $PresentationVBoxC/MarginC/VBoxC/RecherchesMarginC/InterneRecherchesMarginC/VBoxC/PrestigeAmeliorationScrollC/PrestigeGridC
@onready var PrestigeButton = $PresentationVBoxC/MarginC/VBoxC/PrestigeButton

@onready var MainMarginC = $PresentationVBoxC/MarginC
@onready var RecherchesMarginC = $PresentationVBoxC/MarginC/VBoxC/RecherchesMarginC
@onready var ButtonsMarginC = $PresentationVBoxC/MarginC/VBoxC/PrestigeButtonsMarginC
@onready var MoleculesControl = $PresentationVBoxC/MoleculesControl
@onready var MoleculesButton = $PresentationVBoxC/MarginC/VBoxC/PrestigeButtonsMarginC/InterneButtonsMarginC/PrestigeButtonsGridC/MoleculesMarginC2/MoleculesButton


#Initialize la vue de la matière noire
func _ready():
	#On connecte ici l'appuie du bouton lors de l'achat d'une recherche
	RechercheClick.connect("Research_button_pressed", AchatRehercheMatiereNoireButtonPressed)
	RechercheClick.connect("ReturnToDarkMatter_button_pressed", ReturnToDarkMatterButtonPressed)
	
	for rechercheDarkMatterInList in RessourceManager.ListeRecherchesMatiereNoire:
		var newButtonAmeliorationDarkMatter = BoutonRechercheDarkMatter.instantiate()
		newButtonAmeliorationDarkMatter._set_var(rechercheDarkMatterInList)
		RecherchesGridC.add_child(newButtonAmeliorationDarkMatter)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if BonusManager.GetDeltaDarkMatter().isLessThan(Big.new(1.0)):
		PrestigeButton.disabled = true
	else:
		PrestigeButton.disabled = false
	
	if visible:
		MatiereNoireQuantiteeLabel.text = str(RessourceManager.DarkMatter)
		MatierNoireApresPrestige.text = str(BonusManager.GetDeltaDarkMatter())
	
	if InfosPartie.DarkMatterObtenuTotal.isLessThan(Big.new(1.0, 5)):
		MoleculesButton.disabled = true
	else:
		MoleculesButton.disabled = false


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
	var darkMatterObtenu = Big.add(RessourceManager.DarkMatter, BonusManager.GetDeltaDarkMatter())
	RessourceManager.DarkMatter = darkMatterObtenu
	RessourceManager.ResetAtomes()
	RessourceManager.ResetToutesAmeliorations()
	RessourceManager.ResetRecherches()
	InfosPartie.ResetInformationsOnPrestige(darkMatterObtenu)
	RessourceManager.ResetRessources()
	
	BonusManager.MajBonusRecherchesMatiereNoire()


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


func _on_recherches_button_pressed():
	ButtonsMarginC.hide()
	RecherchesMarginC.show()


func _on_molecules_button_pressed():
	MainMarginC.hide()
	MoleculesControl.show()

func ReturnToDarkMatterButtonPressed():
	MoleculesControl.hide()
	RecherchesMarginC.hide()
	MainMarginC.show()
	ButtonsMarginC.show()
