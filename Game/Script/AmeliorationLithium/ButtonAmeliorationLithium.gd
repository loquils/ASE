extends MarginContainer

var AmeliorationLithium: AmeliorationLithium

@onready var ButtonAmeliorationLithium = $ButtonAmelioElectronLithium
@onready var NomAmeliorationLabel = $ButtonAmelioElectronLithium/MainMarginC/PresVBoxC/NomLabel
@onready var DescriptionAmeliorationLabel = $ButtonAmelioElectronLithium/MainMarginC/PresVBoxC/PresHBoxC/DescriptionMarginC/DescriptionLabel
@onready var BonusAmeliorationLabel = $ButtonAmelioElectronLithium/MainMarginC/PresVBoxC/PresHBoxC/DetailsMarginC/DetailsVBoxC/BonusLabel
@onready var NiveauAmeliorationLabel = $ButtonAmelioElectronLithium/MainMarginC/PresVBoxC/PresHBoxC/DetailsMarginC/DetailsVBoxC/NiveauLabel
@onready var PrixAmeliorationLabel = $ButtonAmelioElectronLithium/MainMarginC/PresVBoxC/PresHBoxC/DetailsMarginC/DetailsVBoxC/PrixLabel

@onready var UnlockPanel = $PanelForUnlock


# Called when the node enters the scene tree for the first time.
func _ready():
	ButtonAmeliorationLithium.pressed.connect(RechercheClick.AmeliorationLithiumButtonEventTrigger.bind(AmeliorationLithium))
	UnlockPanel._set_objects(AmeliorationLithium)


func _set_var(ameliorationLithium:AmeliorationLithium):
	AmeliorationLithium = ameliorationLithium


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	NomAmeliorationLabel.text = tr(AmeliorationLithium.Name)
	DescriptionAmeliorationLabel.text = tr(AmeliorationLithium.Description)
	
	if (AmeliorationLithium.BonusTypeAmeliorationLithium == "ProtonEfficacitee"):
		BonusAmeliorationLabel.text = "+" + str(Big.multiply(BonusManager.GetAmeliorationLithiumCoefficientProton(), Big.new(1.0,2))) + "%"
	elif (AmeliorationLithium.BonusTypeAmeliorationLithium == "NeutronEfficacitee"):
		BonusAmeliorationLabel.text = "+/" + str(BonusManager.GetAmeliorationLithiumCoefficientNeutron())
	elif (AmeliorationLithium.BonusTypeAmeliorationLithium == "ElectronsKEfficacitee"):
		var bonusElectrons = BonusManager.GetAmeliorationLithiumCoefficientElectronsLAvecNiveaux()
		BonusAmeliorationLabel.text = "+" + str(Big.multiply(bonusElectrons, Big.new(1.0,2))) + "% | +/" + str(bonusElectrons)
	
	NiveauAmeliorationLabel.text = tr("Niv.") + str(AmeliorationLithium.Level)
	PrixAmeliorationLabel.text = tr("Prix") + str(AmeliorationLithium.GetPrixAmeliorationLithium())
	
	if UnlockPanel.visible:
		if AmeliorationLithium.IsUnlocked:
			UnlockPanel.visible = false
	else:
		if not AmeliorationLithium.IsUnlocked:
			UnlockPanel.visible = true
	
	if AmeliorationLithium.IsUnlocked:
		if RessourceManager.QuantiteesAtomes.has("Lithium"):
			if RessourceManager.QuantiteesAtomes["Lithium"].isLessThan(AmeliorationLithium.GetPrixAmeliorationLithium()):
				ButtonAmeliorationLithium.disabled = true
			else : 
				ButtonAmeliorationLithium.disabled = false
