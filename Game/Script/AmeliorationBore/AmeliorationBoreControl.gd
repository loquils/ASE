extends Control

@onready var ClassicAmeliorationsListe = $PresentationVBoxC/ClassicAmeliorationsMarginC/ClassicAmeliorationsVBoxC/ContenuMarginC/AmeliorationsHBoxC
@onready var AdvancedAmeliorationsListe = $PresentationVBoxC/AdvancedAmeliorationsMarginC/AdvancedAmeliorationsVBoxC/ContenuMarginC/AmeliorationsVBoxC

@onready var QuantiteeBore = $PresentationVBoxC/TopMarginC/VBoxC/TopHBoxC/GUIMarginC

@onready var UniqueBonusBeryOutputLabel = $PresentationVBoxC/MiddleMarginC/HBoxC/VBoxC/BonusBerylliumMarginC/BonusBerylliumPanel/BonusEtQuantiteHBoxC/FondBonusQuantPanel/HBoxC/UniqueBonusVBoxC/UniqueBonusLabel
@onready var TotalBonusBeryOutputLabel = $PresentationVBoxC/MiddleMarginC/HBoxC/VBoxC/BonusBerylliumMarginC/BonusBerylliumPanel/BonusEtQuantiteHBoxC/FondBonusQuantPanel/HBoxC/TotalBonusVBoxC/TotalBonusLabel
@onready var UniqueBonusDMOutputLabel = $PresentationVBoxC/MiddleMarginC/HBoxC/VBoxC/BonusDarkMatterMarginC/BonusDarkMatterPanel/BonusEtQuantiteHBoxC/FondBonusQuantPanel/HBoxC/UniqueBonusVBoxC/UniqueBonusLabel
@onready var TotalBonusDMOutputLabel = $PresentationVBoxC/MiddleMarginC/HBoxC/VBoxC/BonusDarkMatterMarginC/BonusDarkMatterPanel/BonusEtQuantiteHBoxC/FondBonusQuantPanel/HBoxC/TotalBonusVBoxC/TotalBonusLabel
@onready var QuantiteeMatiereLabel = $PresentationVBoxC/MiddleMarginC/HBoxC/QuantiteeMatiereMarginC/PresentationPanelC/MarginC/VBoxC/QuantiteeMatiere

var CustomButtonClassicAmeliorationBore = preload("res://Design/Scenes/Ameliorations/ButtonClassicAmeliorationBore.tscn")
var CustomButtonAdvancedAmeliorationBore = preload("res://Design/Scenes/Ameliorations/ButtonAdvancedAmeliorationBore.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	RechercheClick.connect("AmeliorationBore_button_pressed", AchatAmeliorationBoreButtonPressed)
	QuantiteeBore._set_var("Bore", Big.new(0.0))
	
	for ameliorationBore in RessourceManager.ListeAmeliorationsBore:
		match ameliorationBore.TypeAmeliorationBore:
			AmeliorationBore.TypeAmeliorationBoreEnum.Classic:
				var newAmeliorationBoreButton = CustomButtonClassicAmeliorationBore.instantiate()
				newAmeliorationBoreButton._set_var(ameliorationBore)
				ClassicAmeliorationsListe.add_child(newAmeliorationBoreButton)
			AmeliorationBore.TypeAmeliorationBoreEnum.Advanced:
				var newAmeliorationBoreButton = CustomButtonAdvancedAmeliorationBore.instantiate()
				newAmeliorationBoreButton._set_var(ameliorationBore)
				AdvancedAmeliorationsListe.add_child(newAmeliorationBoreButton)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	UniqueBonusBeryOutputLabel.text = "+" + str(Big.multiply(BonusManager.GetAmeliorationBoreBerylliumCurrentBonus(), Big.new(1.0, 2))) + "%"
	TotalBonusBeryOutputLabel.text = "+" + str(Big.multiply(BonusManager.GetAmeliorationBoreOutputBonus("Beryllium"), Big.new(1.0, 2))) + "%"
	UniqueBonusDMOutputLabel.text = "+" + str(Big.multiply(BonusManager.GetAmeliorationBoreDarkMatterCurrentBonus(), Big.new(1.0, 2))) + "%"
	TotalBonusDMOutputLabel.text = "+" + str(Big.multiply(BonusManager.GetAmeliorationBoreDMOutputBonus(), Big.new(1.0, 2))) + "%"
	QuantiteeMatiereLabel.text = str(BonusManager.GetAmeliorationBoreQuantiteeMatiereAvecBonus())


#Trigger lors de l'appuie sur un bouton pour augmenter une amélioration de lithium
func AchatAmeliorationBoreButtonPressed(ameliorationBore:AmeliorationBore):
	if ameliorationBore.GetPrixAmeliorationBore().isLessThanOrEqualTo(RessourceManager.QuantiteesAtomes["Bore"]):
		RessourceManager.QuantiteesAtomes["Bore"] = Big.subtractAbove0(RessourceManager.QuantiteesAtomes["Bore"], ameliorationBore.GetPrixAmeliorationBore())
		ameliorationBore.Level = Big.add(ameliorationBore.Level, Big.new(1.0))
		
		BonusManager.MajBonusAmeliorationBore()


#Trigger lors de l'appuie sur le bouton exit
func _on_button_exit_pressed():
	hide()
