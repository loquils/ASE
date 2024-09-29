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
@onready var UnlockAtomeNomLabel = $PanelForUnlock/FondPanel/VBoxContainer/AtomeLabel
@onready var UnlockAtomePrixLabel = $PanelForUnlock/FondPanel/VBoxContainer/PrixLabel
@onready var AmeliorationBoreUnlockButton= $PanelForUnlock/FondPanel/VBoxContainer/AmeliorationBoreUnlockButton


#Définition de l'UI du bouton personnalisé.
func _set_var(ameliorationBore):
	AmeliorationBore = ameliorationBore


# Called when the node enters the scene tree for the first time.
func _ready():
	ButtonAmeliorationBore.pressed.connect(RechercheClick.AmeliorationBoreButtonEventTrigger.bind(AmeliorationBore))
	UnlockAtomePrixLabel.text = str(AmeliorationBore.AtomePriceForUnlocking.values()[0])
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
		UnlockAtomeNomLabel.text = tr(AmeliorationBore.AtomePriceForUnlocking.keys()[0])
		
		if AmeliorationBore.IsUnlocked:
			UnlockPanel.visible = false
		
		if RessourceManager.QuantiteesAtomes[AmeliorationBore.AtomePriceForUnlocking.keys()[0]].isLessThan(AmeliorationBore.AtomePriceForUnlocking.values()[0]):
			AmeliorationBoreUnlockButton.disabled = true
		else:
			AmeliorationBoreUnlockButton.disabled = false
	else:
		if not AmeliorationBore.IsUnlocked:
			UnlockPanel.visible = true
			return
	
	if AmeliorationBore.IsUnlocked:
		if RessourceManager.QuantiteesAtomes.has("Bore"):
			if RessourceManager.QuantiteesAtomes["Bore"].isLessThan(AmeliorationBore.GetPrixAmeliorationBore()):
				ButtonAmeliorationBore.disabled = true
			else : 
				ButtonAmeliorationBore.disabled = false


#Lors du clic pour unlock une recherche de bore, enlève le bore (prix) et débloque la recherche.
func _on_amelioration_bore_unlock_button_pressed():
	print("Bouton Unlock bore amélioration :" + AmeliorationBore.Name)
	if AmeliorationBore.IsUnlocked:
		return
	
	if RessourceManager.QuantiteesAtomes[AmeliorationBore.AtomePriceForUnlocking.keys()[0]].isLessThan(AmeliorationBore.AtomePriceForUnlocking.values()[0]):
		return
			
	RessourceManager.QuantiteesAtomes[AmeliorationBore.AtomePriceForUnlocking.keys()[0]] = Big.subtractAbove0(RessourceManager.QuantiteesAtomes[AmeliorationBore.AtomePriceForUnlocking.keys()[0]], AmeliorationBore.AtomePriceForUnlocking.values()[0])
		
	AmeliorationBore.IsUnlocked = true
	
	BonusManager.MajBonusAmeliorationBore()
