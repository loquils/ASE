extends Button

var AmeliorationHelium


@onready var NomLabel = $PanelC/MarginC/HBoxC/LeftVBoxC/NomLabel
@onready var DescriptionLabel = $PanelC/MarginC/HBoxC/LeftVBoxC/DescriptionLabel
@onready var NiveauLabel = $PanelC/MarginC/HBoxC/RightVBoxC/NiveauLabel
@onready var BonusLabel = $PanelC/MarginC/HBoxC/LeftVBoxC/BonusLabel

@onready var UnlockPanel = $PanelForUnlock


func _set_var(ameliorationHelium:AmeliorationHelium):
	AmeliorationHelium = ameliorationHelium

	match AmeliorationHelium.TypeAmeliorationHelium:
		AmeliorationHelium.TypeAmeliorationHeliumEnum.Pression:
			add_theme_stylebox_override("normal", preload("res://Design/Themes/AmeliorationHelium/PressionNormalFlat.tres"))
			add_theme_stylebox_override("disabled", preload("res://Design/Themes/AmeliorationHelium/PressionDisabledFlat.tres"))
		AmeliorationHelium.TypeAmeliorationHeliumEnum.Temperature:
			add_theme_stylebox_override("normal", preload("res://Design/Themes/AmeliorationHelium/TemperatureNormalFlat.tres"))
			add_theme_stylebox_override("disabled", preload("res://Design/Themes/AmeliorationHelium/TemperatureDisabledFlat.tres"))


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(RechercheClick.AmeliorationHeliumButtonEventTrigger.bind(AmeliorationHelium))
	UnlockPanel._set_objects(AmeliorationHelium)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	NomLabel.text = tr(AmeliorationHelium.Name)
	var descriptionTraduite = tr(AmeliorationHelium.Description)
	var bonusNumberToPrint = Big.new(0.0)
	
	match AmeliorationHelium.BonusTypeAmeliorationHelium:
		"HydrogeneOutputMultiply":
			bonusNumberToPrint = str(Big.multiply(BonusManager.GetAmeliorationHeliumPressionMultiplicateur(), Big.new(1.0, 2)))
		
		"PressionEfficacitee0":
			bonusNumberToPrint = str(Big.multiply(BonusManager.GetAmeliorationHeliumCoefficientPression0(), Big.new(1.0, 2)))
			BonusLabel.text = tr("AMELIORATIONHELIUM1") + " +" + str(Big.multiply(BonusManager.GetAmeliorationHeliumCoefficientPression0AvecNiveau(), Big.new(1.0, 2))) + "%"
			BonusLabel.show()
		
		"PressionEfficacitee1":
			bonusNumberToPrint = str(Big.multiply(BonusManager.GetAmeliorationHeliumCoefficientPression1(), Big.new(1.0, 2)))
			BonusLabel.text = tr("AMELIORATIONHELIUM2") + " +" + str(Big.multiply(BonusManager.GetAmeliorationHeliumCoefficientPression1AvecNiveau(), Big.new(1.0, 2))) + "%"
			BonusLabel.show()
		
		"HydrogeneAttributsCoefficientAdd":
			bonusNumberToPrint = str(BonusManager.GetAmeliorationHeliumTemperatureMultiplicateur())
		
		"TemperatureEfficacitee0":
			bonusNumberToPrint = str(BonusManager.GetAmeliorationHeliumCoefficientTemperature0())
			BonusLabel.text = tr("AMELIORATIONHELIUM3") + " +" + str(BonusManager.GetAmeliorationHeliumCoefficientTemperature0AvecNiveau())
			BonusLabel.show()
		
		"TemperatureEfficacitee1":
			bonusNumberToPrint = str(BonusManager.GetAmeliorationHeliumCoefficientTemperature1())
			BonusLabel.text = tr("AMELIORATIONHELIUM4") + " +" + str(BonusManager.GetAmeliorationHeliumCoefficientTemperature1AvecNiveau())
			BonusLabel.show()
	
	DescriptionLabel.text = descriptionTraduite.replace("{calc}", bonusNumberToPrint)
	
	
	if UnlockPanel.visible:
		if AmeliorationHelium.IsUnlocked:
			UnlockPanel.visible = false
	else:
		if not AmeliorationHelium.IsUnlocked:
			UnlockPanel.visible = true
		
		NiveauLabel.text = tr("Niv.") + str(AmeliorationHelium.Level)
		$PanelC/MarginC/HBoxC/RightVBoxC/PrixLabel.text = str(AmeliorationHelium.GetPrixAmeliorationHelium()) + " He"
		
		if RessourceManager.QuantiteesAtomes.has("Helium"):
			if RessourceManager.QuantiteesAtomes["Helium"].isLessThan(AmeliorationHelium.GetPrixAmeliorationHelium()):
				disabled = true
			else : 
				disabled = false
