extends Button

var AmeliorationHelium

func _set_var(ameliorationHelium:AmeliorationHelium):
	AmeliorationHelium = ameliorationHelium
	$HBoxContainer/LeftVBoxContainer/NomLabel.text = AmeliorationHelium.Name
	$HBoxContainer/LeftVBoxContainer/DescriptionLabel.text = AmeliorationHelium.Description
	$HBoxContainer/LeftVBoxContainer/BonusLabel.text = "bonus !"
	$HBoxContainer/RightVBoxContainer/NiveauLabel.text = "Niv." + str(AmeliorationHelium.Level)
	$HBoxContainer/RightVBoxContainer/PrixLabel.text = str(AmeliorationHelium.GetPrixAmeliorationHelium())
	
	$PanelForUnlock/VBoxContainer/AtomeLabel.text = "Coins"
	$PanelForUnlock/VBoxContainer/PrixLabel.text = str(AmeliorationHelium.AtomePriceForUnlocking["Coins"])
	

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
			$PanelForUnlock/VBoxContainer/AmeliorationHeliumUnlockButton.disabled = true
		else:
			$PanelForUnlock/VBoxContainer/AmeliorationHeliumUnlockButton.disabled = false
	else:
		$HBoxContainer/RightVBoxContainer/NiveauLabel.text = "Niv." + str(AmeliorationHelium.Level)
		$HBoxContainer/RightVBoxContainer/PrixLabel.text = str(AmeliorationHelium.GetPrixAmeliorationHelium()) + "He"


func _on_amelioration_helium_unlock_button_pressed():
	print("Bouton Unlock helium amélioration :" + AmeliorationHelium.Name)
	if AmeliorationHelium.IsUnlocked:
		return
	
	if RessourceManager.Coins.compare(AmeliorationHelium.AtomePriceForUnlocking["Coins"]) < 0:
		return
	
	RessourceManager.Coins = RessourceManager.Coins.minus(AmeliorationHelium.AtomePriceForUnlocking["Coins"])
	
	AmeliorationHelium.IsUnlocked = true
	
