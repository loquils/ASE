extends Control

var AmeliorationBore

@onready var NomAmeliorationLabel = $PresentationPanel/PresentationVBoxC/NomMarginC/PanelC/MarginC/NomLabel
@onready var DescriptionAmeliorationLabel = $PresentationPanel/PresentationVBoxC/MidMarginC/DescriptionMarginC/VBoxC/DescriptionLabel
@onready var BonusAmeliorationLabel = $PresentationPanel/PresentationVBoxC/MidMarginC/DescriptionMarginC/VBoxC/BonusMarginC/FondBonusPanel/MarginC/BonusLabel
@onready var NiveauAmeliorationLabel = $PresentationPanel/PresentationVBoxC/BotMarginC/PanelContainer/HBoxC/NiveauMarginC/NiveauLabel
@onready var PrixAmeliorationLabel = $PresentationPanel/PresentationVBoxC/BotMarginC/PanelContainer/HBoxC/PrixContainer/PrixLabel
@onready var ButtonAmeliorationBore = $Button

@onready var NiveauAmeliorationMarginC = $PresentationPanel/PresentationVBoxC/BotMarginC/PanelContainer/HBoxC/NiveauMarginC

@onready var UnlockPanel = $PanelForUnlock

#Définition de l'UI du bouton personnalisé.
func _set_var(ameliorationBore):
	AmeliorationBore = ameliorationBore


# Called when the node enters the scene tree for the first time.
func _ready():
	UnlockPanel._set_objects(AmeliorationBore)
	ButtonAmeliorationBore.pressed.connect(RechercheClick.AmeliorationBoreButtonEventTrigger.bind(AmeliorationBore))
	
	if AmeliorationBore.BonusTypeAmeliorationBore == "QuantiteeMatiere":
		NiveauAmeliorationMarginC.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	NomAmeliorationLabel.text = tr(AmeliorationBore.Name)
	DescriptionAmeliorationLabel.text = tr(AmeliorationBore.Description)
	
	NiveauAmeliorationLabel.text = tr("Niv.") + str(AmeliorationBore.Level)
	PrixAmeliorationLabel.text = tr("Prix") + str(AmeliorationBore.GetPrixAmeliorationBore())
	
	match AmeliorationBore.BonusTypeAmeliorationBore:
		"QuantiteeMatiere":
			BonusAmeliorationLabel.text = "Quantitee Matiere +" + str(BonusManager.GetAmeliorationBoreQuantiteeMatiereUnique(AmeliorationBore))
		"BonusQuantiteeMatiere":
			BonusAmeliorationLabel.text = "Bonus/Niv +" + str(Big.multiply(BonusManager.GetAmeliorationBoreQuantiteeUniqueBonus(AmeliorationBore), Big.new(1.0, 2))) + "%"
	
	if UnlockPanel.visible:
		if AmeliorationBore.IsUnlocked:
			UnlockPanel.visible = false
	else:
		if not AmeliorationBore.IsUnlocked:
			UnlockPanel.visible = true
	
	if AmeliorationBore.IsUnlocked:
		if RessourceManager.QuantiteesAtomes.has("Bore"):
			if RessourceManager.QuantiteesAtomes["Bore"].isLessThan(AmeliorationBore.GetPrixAmeliorationBore()):
				ButtonAmeliorationBore.disabled = true
			else : 
				ButtonAmeliorationBore.disabled = false
