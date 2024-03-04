extends Button

var AmeliorationHelium

@onready var AmeliorationHeliumUnlockButton = $PanelForUnlock/VBoxContainer/AmeliorationHeliumUnlockButton

func _set_var(ameliorationHelium:AmeliorationHelium):
	AmeliorationHelium = ameliorationHelium
	$PanelC/MarginC/HBoxC/LeftVBoxC/NomLabel.text = AmeliorationHelium.Name
	$PanelC/MarginC/HBoxC/LeftVBoxC/DescriptionLabel.text = AmeliorationHelium.Description
	$PanelC/MarginC/HBoxC/LeftVBoxC/BonusLabel.text = "bonus !"
	$PanelC/MarginC/HBoxC/RightVBoxC/NiveauLabel.text = "Niv." + str(AmeliorationHelium.Level)
	$PanelC/MarginC/HBoxC/RightVBoxC/PrixLabel.text = str(AmeliorationHelium.GetPrixAmeliorationHelium())
	
	$PanelForUnlock/VBoxContainer/AtomeLabel.text = "Coins"
	$PanelForUnlock/VBoxContainer/PrixLabel.text = str(AmeliorationHelium.AtomePriceForUnlocking["Coins"])
	
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
	if $PanelForUnlock.visible:
		if AmeliorationHelium.IsUnlocked:
			$PanelForUnlock.visible = false
		
		#On test si le bouton est disabled ou pas
		if RessourceManager.Coins.compare(AmeliorationHelium.AtomePriceForUnlocking["Coins"]) < 0:
			AmeliorationHeliumUnlockButton.disabled = true
		else:
			AmeliorationHeliumUnlockButton.disabled = false
	else:
		$PanelC/MarginC/HBoxC/RightVBoxC/NiveauLabel.text = "Niv." + str(AmeliorationHelium.Level)
		$PanelC/MarginC/HBoxC/RightVBoxC/PrixLabel.text = str(AmeliorationHelium.GetPrixAmeliorationHelium()) + " He"
		
		if RessourceManager.QuantiteesAtomes["Helium"].compare(AmeliorationHelium.GetPrixAmeliorationHelium()) < 0:
			disabled = true
		else : 
			disabled = false


func _on_amelioration_helium_unlock_button_pressed():
	print("Bouton Unlock helium amélioration :" + AmeliorationHelium.Name)
	if AmeliorationHelium.IsUnlocked:
		return
	
	if RessourceManager.Coins.compare(AmeliorationHelium.AtomePriceForUnlocking["Coins"]) < 0:
		return
	
	RessourceManager.Coins = RessourceManager.Coins.minus(AmeliorationHelium.AtomePriceForUnlocking["Coins"])
	
	AmeliorationHelium.IsUnlocked = true
	
