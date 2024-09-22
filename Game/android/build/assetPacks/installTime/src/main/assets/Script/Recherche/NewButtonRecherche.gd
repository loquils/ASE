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


#Connecte les signaux aux méthodes d'action.
func _ready():
	RechercheButton.pressed.connect(RechercheClick.RechercheButtonEventTrigger.bind(Recherche))
	RechercheButton.pressed.connect(ChangeButtonStateToBought)


#On met a jour l'UI en bloquant le bouton :).
func _process(_delta):
	NomLabel.text = tr(Recherche.Name)
	DescriptionLabel.text = GetRechercheDescriptionText()
	PrixLabel.text = tr("Prix : ") + str(Recherche.Prix)
	
	if not Recherche.IsUnlocked:
		if AchatPanel.visible:
			RechercheButton.disabled = false
			AchatPanel.visible = false
		
		if Recherche.ResearchLevel == Recherche.ResearchLevelEnum.DARKMATTER:
			if Recherche.Prix.isGreaterThan(RessourceManager.DarkMatter):
				RechercheButton.disabled = true
			else:
				RechercheButton.disabled = false
		else:
			if Recherche.Prix.isGreaterThan(RessourceManager.Coins):
				RechercheButton.disabled = true
			else:
				RechercheButton.disabled = false
	else:
		if not AchatPanel.visible:
			ChangeButtonStateToBought()
		AchatNomLabel.text = tr(Recherche.Name)
		AchatDescriptionLabel.text = GetRechercheDescriptionText()
		BonusLabel.text = Recherche.GetRechercheBonusString()


#Permet de récupérer le text de la description automatiquement et traduit.
func GetRechercheDescriptionText():
	var description = tr(Recherche.Description.replace("PARRECHERCHEMN", "").replace("PARRECHERCHE", ""))
	var rechercheElements = Recherche.GetRechercheElements()
	
	var elementsString = ""
	for i in range(len(rechercheElements)):
		if i == len(rechercheElements) - 1 and len(rechercheElements) != 1:
			elementsString += tr("ET")
			
		if rechercheElements[i].substr(1, 1) == 'H':
			elementsString += tr("DAPPO")
		else:
			elementsString += tr("DE")
		
		elementsString += tr(rechercheElements[i]).trim_prefix(" ")
		if i != len(rechercheElements) - 1 and i != len(rechercheElements) - 2:
			elementsString += ", "
	
	description = description.replace("{elements}", elementsString)
	description = description.replace("{calc}", Recherche.GetRechercheString())
	
	if Recherche.Description.contains("PARRECHERCHEMN"):
		description = description.insert(len(description) - 1 ,tr("PARRECHERCHEMN"))
	elif Recherche.Description.contains("PARRECHERCHE"):
		description = description.insert(len(description) - 1 ,tr("PARRECHERCHE"))
	
	return description


#Methode trigger lors de l'appuie sur ce bouton
#Si la recherche est bien achetée, il faut changer la stucture du bouton :
func ChangeButtonStateToBought():
	if Recherche.IsUnlocked:
		RechercheButton.disabled = true
		AchatPanel.visible = true
