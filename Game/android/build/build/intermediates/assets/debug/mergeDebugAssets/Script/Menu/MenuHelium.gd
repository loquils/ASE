extends Control


var CustomButtonAmeliorationHelium = preload("res://Design/Scenes/ButtonAmelioHelium.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	RechercheClick.connect("AmeliorationHelium_button_pressed", AchatAmeliorationHeliumButtonPressed)

	for ameliorationHelium in RessourceManager.ListeAmeliorationsHelium:
		var newAmeliorationHeliumButton = CustomButtonAmeliorationHelium.instantiate()
		newAmeliorationHeliumButton._set_var(ameliorationHelium)
		match ameliorationHelium.TypeAmeliorationHelium:
			AmeliorationHelium.TypeAmeliorationHeliumEnum.Pression:
				$PresentationVBoxC/PressionPanelC/PressionVBoxC/ScrollC/ListeHeliumUpgradesVBoxC.add_child(newAmeliorationHeliumButton)
			AmeliorationHelium.TypeAmeliorationHeliumEnum.Temperature:
				$PresentationVBoxC/TemperaturePanelC/TemperatureVBoxC/ScrollC/ListeHeliumUpgradesVBoxC.add_child(newAmeliorationHeliumButton)
	
	BonusManager.MajBonusAmeliorationHelium()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		#$DebugLabel.text = str(CurrentBonusesAmeliorationHelium[BonusTypesAmeliorationHelium[0]])
	pass


#Trigger lors de l'appuie sur un bouton pour augmenter une amélioration de l'helium
func AchatAmeliorationHeliumButtonPressed(ameliorationHelium):
	if ameliorationHelium.GetPrixAmeliorationHelium().compare(RessourceManager.QuantiteesAtomes["Helium"]) <= 0:
		RessourceManager.QuantiteesAtomes["Helium"] = RessourceManager.QuantiteesAtomes["Helium"].minus(ameliorationHelium.GetPrixAmeliorationHelium())
		ameliorationHelium.Level = ameliorationHelium.Level.add(CustomNumber.new(1.0))
		print("Amélioration Helium " + ameliorationHelium.Name + " achetée ! Niveau : " + str(ameliorationHelium.Level))
		BonusManager.MajBonusAmeliorationHelium()


func _on_button_exit_pressed():
	hide()
