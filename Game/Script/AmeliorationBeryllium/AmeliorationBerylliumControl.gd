extends Control

@onready var QuantiteeHydrogene = $PresentationVBoxC/TopMarginC/VBoxC/TopHBoxC/GUIMarginC
@onready var QuantiteeHelium = $PresentationVBoxC/TopMarginC/VBoxC/TopHBoxC/GUIMarginC2
@onready var QuantiteeLithium = $PresentationVBoxC/TopMarginC/VBoxC/TopHBoxC2/GUIMarginC
@onready var QuantiteeBeryllium = $PresentationVBoxC/TopMarginC/VBoxC/TopHBoxC2/GUIMarginC2

@onready var AmeliorationsNormalVBoxC = $PresentationVBoxC/AmeliorationsMarginC/AmeliorationsVBoxC/MarginC/FondPanel/PresVBoxC/AmeliorationsHBoxC/NormalMarginC/VBoxC
@onready var AmeliorationsBonusAddVBoxC = $PresentationVBoxC/AmeliorationsMarginC/AmeliorationsVBoxC/MarginC/FondPanel/PresVBoxC/AmeliorationsHBoxC/BonusAddMarginC/VBoxC

@onready var HydrogeneBaseBonusLabel = $PresentationVBoxC/MiddleMarginC/VBoxContainer/BaseBonusesMarginC/HBoxC/HydrogeneFondPanel/MarginC/VBoxC/BonusLabel
@onready var HeliumBaseBonusLabel = $PresentationVBoxC/MiddleMarginC/VBoxContainer/BaseBonusesMarginC/HBoxC/HeliumFondPanel/MarginC/VBoxC/BonusLabel
@onready var LithiumBaseBonusLabel = $PresentationVBoxC/MiddleMarginC/VBoxContainer/BaseBonusesMarginC/HBoxC/LithiumFondPanel/MarginC/VBoxC/BonusLabel
@onready var BerylliumBaseBonusLabel = $PresentationVBoxC/MiddleMarginC/VBoxContainer/BaseBonusesMarginC/HBoxC/BerylliumFondPanel/MarginC/VBoxC/BonusLabel

@onready var HydrogeneLevelLabel = $PresentationVBoxC/MiddleMarginC/VBoxContainer/CurrentLevelsMarginC/HBoxC/HydrogeneFondPanel/MarginC/VBoxC/BonusLabel
@onready var HeliumLevelLabel = $PresentationVBoxC/MiddleMarginC/VBoxContainer/CurrentLevelsMarginC/HBoxC/HeliumFondPanel/MarginC/VBoxC/BonusLabel
@onready var LithiumLevelLabel = $PresentationVBoxC/MiddleMarginC/VBoxContainer/CurrentLevelsMarginC/HBoxC/LithiumFondPanel/MarginC/VBoxC/BonusLabel
@onready var BerylliumLevelLabel = $PresentationVBoxC/MiddleMarginC/VBoxContainer/CurrentLevelsMarginC/HBoxC/BerylliumFondPanel/MarginC/VBoxC/BonusLabel

@onready var HydrogeneTotalLabel = $PresentationVBoxC/MiddleMarginC/VBoxContainer/CurrentLevelsMarginC/HBoxC/HydrogeneFondPanel/MarginC/VBoxC/TotalBonusLabel
@onready var HeliumTotalLabel = $PresentationVBoxC/MiddleMarginC/VBoxContainer/CurrentLevelsMarginC/HBoxC/HeliumFondPanel/MarginC/VBoxC/TotalBonusLabel
@onready var LithiumTotalLabel = $PresentationVBoxC/MiddleMarginC/VBoxContainer/CurrentLevelsMarginC/HBoxC/LithiumFondPanel/MarginC/VBoxC/TotalBonusLabel
@onready var BerylliumTotalLabel = $PresentationVBoxC/MiddleMarginC/VBoxContainer/CurrentLevelsMarginC/HBoxC/BerylliumFondPanel/MarginC/VBoxC/TotalBonusLabel


var CustomButtonAmeliorationBeryllium = preload("res://Design/Scenes/Ameliorations/ButtonAmeliorationBeryllium.tscn")

func _ready():
	RechercheClick.connect("AmeliorationBeryllium_button_pressed", AchatAmeliorationBerylliumButtonPressed)
	
	QuantiteeHydrogene._set_var("Hydrogene", Big.new(0.0))
	QuantiteeHelium._set_var("Helium", Big.new(0.0))
	QuantiteeLithium._set_var("Lithium", Big.new(0.0))
	QuantiteeBeryllium._set_var("Beryllium", Big.new(0.0))
	
	for ameliorationBeryllium in RessourceManager.ListeAmeliorationsBeryllium:
		var newAmeliorationBerylliumButton = CustomButtonAmeliorationBeryllium.instantiate()
		newAmeliorationBerylliumButton._set_var(ameliorationBeryllium)
		
		match ameliorationBeryllium.CategorieAmeliorationBeryllium:
			AmeliorationBeryllium.CategorieAmeliorationBerylliumEnum.Normal:
				AmeliorationsNormalVBoxC.add_child(newAmeliorationBerylliumButton)
			AmeliorationBeryllium.CategorieAmeliorationBerylliumEnum.BonusAdd:
				AmeliorationsBonusAddVBoxC.add_child(newAmeliorationBerylliumButton)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var currentOutputBonuses = BonusManager.BaseBonusesAmeliorationsBerylliumPercent
	for bonus in currentOutputBonuses:
		match bonus:
			"HydrogeneOutputMultiply":
				HydrogeneBaseBonusLabel.text = "+" + str(Big.multiply(currentOutputBonuses["HydrogeneOutputMultiply"], Big.new(1.0, 2))) + "%"
			"HeliumOutputMultiply":
				HeliumBaseBonusLabel.text = "+" + str(Big.multiply(currentOutputBonuses["HeliumOutputMultiply"], Big.new(1.0, 2))) + "%"
			"LithiumOutputMultiply":
				LithiumBaseBonusLabel.text = "+" + str(Big.multiply(currentOutputBonuses["LithiumOutputMultiply"], Big.new(1.0, 2))) + "%"
			"BerylliumOutputMultiply":
				BerylliumBaseBonusLabel.text = "+" + str(Big.multiply(currentOutputBonuses["BerylliumOutputMultiply"], Big.new(1.0, 2))) + "%"
	
	var currentLevels = BonusManager.GetAmeliorationBerylliumLevels()
	HydrogeneLevelLabel.text = str(currentLevels[0])
	HeliumLevelLabel.text = str(currentLevels[1])
	LithiumLevelLabel.text = str(currentLevels[2])
	BerylliumLevelLabel.text = str(currentLevels[3])
	
	var totalBonuses = BonusManager.GetAmeliorationBerylliumAllTotalBonuses()
	HydrogeneTotalLabel.text = "+" + str(Big.multiply(totalBonuses[0], Big.new(1.0, 2))) + "%"
	HeliumTotalLabel.text = "+" + str(Big.multiply(totalBonuses[1], Big.new(1.0, 2))) + "%"
	LithiumTotalLabel.text = "+" + str(Big.multiply(totalBonuses[2], Big.new(1.0, 2))) + "%"
	BerylliumTotalLabel.text = "+" + str(Big.multiply(totalBonuses[3], Big.new(1.0, 2))) + "%"

#Trigger lors de l'appuie sur un bouton pour augmenter une amélioration de beryllium
func AchatAmeliorationBerylliumButtonPressed(ameliorationBeryllium:AmeliorationBeryllium):
	var prixAmeliorationBeryllium = ameliorationBeryllium.GetPrixAmeliorationBeryllium()
	
	if prixAmeliorationBeryllium.values()[0].isLessThanOrEqualTo(RessourceManager.QuantiteesAtomes[prixAmeliorationBeryllium.keys()[0]]):
		RessourceManager.QuantiteesAtomes[prixAmeliorationBeryllium.keys()[0]] = Big.subtractAbove0(RessourceManager.QuantiteesAtomes[prixAmeliorationBeryllium.keys()[0]], prixAmeliorationBeryllium.values()[0])
		ameliorationBeryllium.Level = Big.add(ameliorationBeryllium.Level, Big.new(1.0))
		
		BonusManager.MajBonusAmeliorationBeryllium()


#Trigger lors de l'appuie sur le bouton exit
func _on_button_exit_pressed():
	hide()
