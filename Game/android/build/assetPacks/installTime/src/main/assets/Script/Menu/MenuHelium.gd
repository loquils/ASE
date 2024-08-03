extends Control

@onready var QuantiteeHelium = $PresentationVBoxC/TopMarginC/TopHBoxC/GUIMarginC

@onready var BonusPressionLabel = $PresentationVBoxC/MiddleMarginC/RecapHBoxC/VBoxContainer/BonusPressionHBoxC/BonusLabel
@onready var BonusTemperatureLabel = $PresentationVBoxC/MiddleMarginC/RecapHBoxC/VBoxContainer/BonusTemperatureHBoxC/BonusLabel

var CustomButtonAmeliorationHelium = preload("res://Design/Scenes/ButtonAmelioHelium.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	RechercheClick.connect("AmeliorationHelium_button_pressed", AchatAmeliorationHeliumButtonPressed)
	
	QuantiteeHelium._set_var("Helium", Big.new(0.0))
	
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
	BonusPressionLabel.text = "+" + str(Big.multiply(BonusManager.GetAmeliorationHeliumCoefficienSortieAvecNiveau(), Big.new(1.0, 2))) + "%"
	BonusTemperatureLabel.text = "+" + str(BonusManager.GetAmeliorationHeliumCoefficienTemperatureAvecNiveau())


#Trigger lors de l'appuie sur un bouton pour augmenter une amélioration de l'helium
func AchatAmeliorationHeliumButtonPressed(ameliorationHelium):
	if ameliorationHelium.GetPrixAmeliorationHelium().isLessThanOrEqualTo(RessourceManager.QuantiteesAtomes["Helium"]):
		RessourceManager.QuantiteesAtomes["Helium"] = Big.subtractAbove0(RessourceManager.QuantiteesAtomes["Helium"], ameliorationHelium.GetPrixAmeliorationHelium())
		ameliorationHelium.Level = Big.add(ameliorationHelium.Level, Big.new(1.0))
		BonusManager.MajBonusAmeliorationHelium()


func _on_button_exit_pressed():
	hide()
