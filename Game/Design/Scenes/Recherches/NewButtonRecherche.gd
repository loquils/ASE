extends Control

var Recherche

@onready var RechercheButton = $Button

@onready var NomLabel = $PresentationPanel/PresentationVBoxC/NomMarginC/PanelC/MarginC/NomLabel
@onready var DescriptionLabel = $PresentationPanel/PresentationVBoxC/DescriptionMarginC/PanelC/DescriptionLabel
@onready var PrixLabel = $PresentationPanel/PresentationVBoxC/PrixMarginC/PanelC/MarginC/PrixLabel
@onready var PrixContainer = $PresentationPanel/PresentationVBoxC/PrixMarginC

@onready var AchatPanel = $AchatPresentationPanel
@onready var AchatNomLabel = $AchatPresentationPanel/PresentationVBoxC/NomMarginC/PanelC/MarginC/NomLabel
@onready var AchatDescriptionLabel = $AchatPresentationPanel/PresentationVBoxC/DescriptionMarginC/PanelC/DescriptionLabel
@onready var BonusLabel = $AchatPresentationPanel/PresentationVBoxC/BonusMarginC/PanelC/MarginC/BonusLabel


#Définition de l'UI du bouton personnalisé.
func _set_var(recherche):
	Recherche = recherche

func _ready():
	RechercheButton.pressed.connect(RechercheClick.RechercheButtonEventTrigger.bind(Recherche))
	RechercheButton.pressed.connect(ChangeButtonStateToBought)

#On met a jour l'UI en bloquant le bouton :)
func _process(_delta):
	NomLabel.text = tr(Recherche.Name)
	DescriptionLabel.text = tr(Recherche.Description)
	PrixLabel.text = tr("Prix : ") + str(Recherche.Prix)
	
	if not Recherche.IsUnlocked:
		if AchatPanel.visible:
			RechercheButton.disabled = false
			AchatPanel.visible = false
		
		if Recherche.Prix.isGreaterThan(RessourceManager.Coins):
			RechercheButton.disabled = true
		else:
			RechercheButton.disabled = false
	else:
		if not AchatPanel.visible:
			ChangeButtonStateToBought()
		AchatNomLabel.text = tr(Recherche.Name)
		AchatDescriptionLabel.text = tr(Recherche.Description)
		BonusLabel.text = Recherche.GetRechercheBonusString()


#Methode trigger lors de l'appuie sur ce bouton
#Si la recherche est bien achetée, il faut changer la stucture du bouton :
func ChangeButtonStateToBought():
	if Recherche.IsUnlocked:
		RechercheButton.disabled = true
		AchatPanel.visible = true
		print("Recherche achetée :)")
