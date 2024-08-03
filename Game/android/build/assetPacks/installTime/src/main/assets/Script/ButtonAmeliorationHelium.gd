extends Button

var AmeliorationHelium

@onready var AmeliorationHeliumUnlockButton = $PanelForUnlock/VBoxContainer/AmeliorationHeliumUnlockButton
@onready var NomLabel = $PanelC/MarginC/HBoxC/LeftVBoxC/NomLabel
@onready var DescriptionLabel = $PanelC/MarginC/HBoxC/LeftVBoxC/DescriptionLabel
@onready var NiveauLabel = $PanelC/MarginC/HBoxC/RightVBoxC/NiveauLabel
@onready var UnlockPanel = $PanelForUnlock
@onready var UnlockAtomLabel = $PanelForUnlock/VBoxContainer/AtomeLabel

@onready var BonusLabel = $PanelC/MarginC/HBoxC/LeftVBoxC/BonusLabel

func _set_var(ameliorationHelium:AmeliorationHelium):
	AmeliorationHelium = ameliorationHelium
	
	$PanelC/MarginC/HBoxC/RightVBoxC/PrixLabel.text = str(AmeliorationHelium.GetPrixAmeliorationHelium())
	
	if(AmeliorationHelium.AtomePriceForUnlocking.has("Coins")):
		$PanelForUnlock/VBoxContainer/PrixLabel.text = str(AmeliorationHelium.AtomePriceForUnlocking["Coins"])
	else:
		$PanelForUnlock/VBoxContainer/PrixLabel.text = str(AmeliorationHelium.AtomePriceForUnlocking.values()[0])

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
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	NomLabel.text = tr(AmeliorationHelium.Name)
	var descriptionTraduite = tr(AmeliorationHelium.Description)
	var bonusNumberToPrint = Big.new(0.0)
	
	if (AmeliorationHelium.BonusTypeAmeliorationHelium == "HydrogeneOutputMultiply"):
		bonusNumberToPrint = str(Big.multiply(BonusManager.GetAmeliorationHeliumPressionMultiplicateur(), Big.new(1.0, 2)))
	elif (AmeliorationHelium.BonusTypeAmeliorationHelium == "PressionEfficacitee0"):
		bonusNumberToPrint = str(Big.multiply(BonusManager.GetAmeliorationHeliumCoefficienPression0(), Big.new(1.0, 2)))
		BonusLabel.text = tr("AMELIORATIONHELIUMPRESSION1") + " +" + str(Big.multiply(BonusManager.GetAmeliorationHeliumCoefficienPression0AvecNiveau(), Big.new(1.0, 2))) + "%"
		BonusLabel.show()
	elif (AmeliorationHelium.BonusTypeAmeliorationHelium == "PressionEfficacitee1"):
		bonusNumberToPrint = str(Big.multiply(BonusManager.GetAmeliorationHeliumCoefficienPression1(), Big.new(1.0, 2)))
		BonusLabel.text = tr("AMELIORATIONHELIUMPRESSION2") + " +" + str(Big.multiply(BonusManager.GetAmeliorationHeliumCoefficienPression1AvecNiveau(), Big.new(1.0, 2))) + "%"
		BonusLabel.show()
	elif (AmeliorationHelium.BonusTypeAmeliorationHelium == "HydrogeneAttributsCoefficientAdd"):
		bonusNumberToPrint = str(BonusManager.GetAmeliorationHeliumTemperatureMultiplicateur())
	elif (AmeliorationHelium.BonusTypeAmeliorationHelium == "TemperatureEfficacitee0"):
		bonusNumberToPrint = str(BonusManager.GetAmeliorationHeliumCoefficienTemperature0())
		BonusLabel.text = tr("AMELIORATIONHELIUMTEMPERATURE1") + " +" + str(BonusManager.GetAmeliorationHeliumCoefficienTemperature0AvecNiveau())
		BonusLabel.show()
	elif (AmeliorationHelium.BonusTypeAmeliorationHelium == "TemperatureEfficacitee1"):
		bonusNumberToPrint = str(BonusManager.GetAmeliorationHeliumCoefficienTemperature1())
		BonusLabel.text = tr("AMELIORATIONHELIUMTEMPERATURE2") + " +" + str(BonusManager.GetAmeliorationHeliumCoefficienTemperature1AvecNiveau())
		BonusLabel.show()
	
	DescriptionLabel.text = descriptionTraduite.replace("{calc}", bonusNumberToPrint)
	
	
	if UnlockPanel.visible:
		UnlockAtomLabel.text = tr(AmeliorationHelium.AtomePriceForUnlocking.keys()[0])
		
		if AmeliorationHelium.IsUnlocked:
			UnlockPanel.visible = false
		
		#On vérifie si le bouton est disabled ou pas : si on a asser de ressources pour le débloqué ou pas
		if AmeliorationHelium.AtomePriceForUnlocking.has("Coins"):
			if RessourceManager.Coins.isLessThan(AmeliorationHelium.AtomePriceForUnlocking["Coins"]):
				AmeliorationHeliumUnlockButton.disabled = true
			else:
				AmeliorationHeliumUnlockButton.disabled = false
		elif RessourceManager.QuantiteesAtomes[AmeliorationHelium.AtomePriceForUnlocking.keys()[0]].isLessThan(AmeliorationHelium.AtomePriceForUnlocking.values()[0]):
			AmeliorationHeliumUnlockButton.disabled = true
		else:
			AmeliorationHeliumUnlockButton.disabled = false
	else:
		if not AmeliorationHelium.IsUnlocked:
			UnlockPanel.visible = true
			return
		
		NiveauLabel.text = tr("Niv.") + str(AmeliorationHelium.Level)
		$PanelC/MarginC/HBoxC/RightVBoxC/PrixLabel.text = str(AmeliorationHelium.GetPrixAmeliorationHelium()) + " He"
		
		if RessourceManager.QuantiteesAtomes.has("Helium"):
			if RessourceManager.QuantiteesAtomes["Helium"].isLessThan(AmeliorationHelium.GetPrixAmeliorationHelium()):
				disabled = true
			else : 
				disabled = false


func _on_amelioration_helium_unlock_button_pressed():
	print("Bouton Unlock helium amélioration :" + AmeliorationHelium.Name)
	if AmeliorationHelium.IsUnlocked:
		return
	
	if AmeliorationHelium.AtomePriceForUnlocking.has("Coins"):
		if RessourceManager.Coins.isLessThan(AmeliorationHelium.AtomePriceForUnlocking["Coins"]):
			return
			
		RessourceManager.Coins = Big.subtractAbove0(RessourceManager.Coins, AmeliorationHelium.AtomePriceForUnlocking["Coins"])
	else:
		if RessourceManager.QuantiteesAtomes[AmeliorationHelium.AtomePriceForUnlocking.keys()[0]].isLessThan(AmeliorationHelium.AtomePriceForUnlocking.values()[0]):
			return
			
		RessourceManager.QuantiteesAtomes[AmeliorationHelium.AtomePriceForUnlocking.keys()[0]] = Big.subtractAbove0(RessourceManager.QuantiteesAtomes[AmeliorationHelium.AtomePriceForUnlocking.keys()[0]], AmeliorationHelium.AtomePriceForUnlocking.values()[0])
		
	AmeliorationHelium.IsUnlocked = true
