extends Control

var AmeliorationLithium: AmeliorationLithium

@onready var NomAmeliorationLabel = $PresentationVBoxC/TopMarginC/NomMarginC/NomLabel
@onready var DescriptionAmeliorationLabel = $PresentationVBoxC/MidMarginC/DescriptionMarginC/VBoxC/DescriptionLabel
@onready var BonusAmeliorationLabel = $PresentationVBoxC/MidMarginC/DescriptionMarginC/VBoxC/BonusMarginC/FondBonusPanel/MarginC/BonusLabel
@onready var AmeliorationBoutton = $PresentationVBoxC/BotMarginC/ButtonAchatAmelioration
@onready var NiveauAmeliorationLabel = $PresentationVBoxC/BotMarginC/ButtonAchatAmelioration/HBoxC/NiveauMarginC/VBoxC/NiveauLabel
@onready var BonusUniqueAmeliorationLabel = $PresentationVBoxC/BotMarginC/ButtonAchatAmelioration/HBoxC/NiveauMarginC/VBoxC/BonusUniqueLabel
@onready var PrixAmeliorationLabel = $PresentationVBoxC/BotMarginC/ButtonAchatAmelioration/HBoxC/PrixContainer/PrixLabel

@onready var UnlockPanel = $PanelForUnlock
@onready var UnlockAtomeNomLabel = $PanelForUnlock/FondPanel/VBoxContainer/AtomeLabel
@onready var UnlockAtomePrixLabel = $PanelForUnlock/FondPanel/VBoxContainer/PrixLabel
@onready var AmeliorationLithiumUnlockButton= $PanelForUnlock/FondPanel/VBoxContainer/AmeliorationLithiumUnlockButton

func _set_var(ameliorationLithium:AmeliorationLithium):
	AmeliorationLithium = ameliorationLithium
	
# Called when the node enters the scene tree for the first time.
func _ready():
	AmeliorationBoutton.pressed.connect(RechercheClick.AmeliorationLithiumButtonEventTrigger.bind(AmeliorationLithium))
	UnlockAtomePrixLabel.text = str(AmeliorationLithium.AtomePriceForUnlocking.values()[0])
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	NomAmeliorationLabel.text = tr(AmeliorationLithium.Name)
	DescriptionAmeliorationLabel.text = tr(AmeliorationLithium.Description)
	BonusAmeliorationLabel.text = "PasLa"
	NiveauAmeliorationLabel.text = tr("Niv.") + str(AmeliorationLithium.Level)
	PrixAmeliorationLabel.text = tr("Prix") + str(AmeliorationLithium.GetPrixAmeliorationLithium())
	BonusUniqueAmeliorationLabel.text = tr("Bonus +") + str(Big.multiply(AmeliorationLithium.BonusAmeliorationLithium, Big.new(1.0,2))) + "%"
	
	if UnlockPanel.visible:
		UnlockAtomeNomLabel.text = tr(AmeliorationLithium.AtomePriceForUnlocking.keys()[0])
		
		if AmeliorationLithium.IsUnlocked:
			UnlockPanel.visible = false
		
		if RessourceManager.QuantiteesAtomes[AmeliorationLithium.AtomePriceForUnlocking.keys()[0]].isLessThan(AmeliorationLithium.AtomePriceForUnlocking.values()[0]):
			AmeliorationLithiumUnlockButton.disabled = true
		else:
			AmeliorationLithiumUnlockButton.disabled = false
	else:
		if not AmeliorationLithium.IsUnlocked:
			UnlockPanel.visible = true
			return
		
	if RessourceManager.QuantiteesAtomes.has("Lithium"):
		if RessourceManager.QuantiteesAtomes["Lithium"].isLessThan(AmeliorationLithium.GetPrixAmeliorationLithium()):
			AmeliorationBoutton.disabled = true
		else : 
			AmeliorationBoutton.disabled = false


func _on_amelioration_lithium_unlock_button_pressed():
	print("Bouton Unlock lithium amélioration :" + AmeliorationLithium.Name)
	if AmeliorationLithium.IsUnlocked:
		return
	
	if RessourceManager.QuantiteesAtomes[AmeliorationLithium.AtomePriceForUnlocking.keys()[0]].isLessThan(AmeliorationLithium.AtomePriceForUnlocking.values()[0]):
		return
			
	RessourceManager.QuantiteesAtomes[AmeliorationLithium.AtomePriceForUnlocking.keys()[0]] = Big.subtractAbove0(RessourceManager.QuantiteesAtomes[AmeliorationLithium.AtomePriceForUnlocking.keys()[0]], AmeliorationLithium.AtomePriceForUnlocking.values()[0])
		
	AmeliorationLithium.IsUnlocked = true
