extends Control

var Attribut

@onready var AttributButton = $Button

@onready var NomLabel = $PresentationPanel/PresentationVBoxC/NomMarginC/NomLabel
@onready var CoefficientLabel = $PresentationPanel/PresentationVBoxC/CoefficientMarginC/CoefficientLabel
@onready var PrixLabel = $PresentationPanel/PresentationVBoxC/PrixMarginC/VBoxC/PrixLabel
@onready var NiveauLabel = $PresentationPanel/PresentationVBoxC/NiveauMarginC/PanelC/MarginC/NiveauLabel

func _set_var(attribut):
	Attribut = attribut

func _ready():
	AttributButton.pressed.connect(RechercheClick.AttributButtonEventTrigger.bind(Attribut))

func _process(_delta):
	NomLabel.text = tr(Attribut.Name)
	CoefficientLabel.text = tr("Coefficient : ") + str(Attribut.GetAttributCoefficientAvecAmeliorations())
	PrixLabel.text = str(Attribut.Atome.GetPrixAttribut(Attribut))
	NiveauLabel.text = tr("Niv.") + str(Attribut.Niveau)
	
	if Attribut.Atome.GetPrixAttribut(Attribut).isGreaterThan(RessourceManager.Coins):
		AttributButton.disabled = true
	else:
		AttributButton.disabled = false
