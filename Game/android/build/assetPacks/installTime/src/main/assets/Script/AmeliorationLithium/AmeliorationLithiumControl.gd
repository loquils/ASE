extends Control

@onready var NoyauSprite2D = $Node2DLithium/NoyauSprite2D
@onready var AmeliorationNoyauMenu = $PresentationVBoxC/MenuNoyauMarginC
@onready var AmeliorationElectronMenu = $PresentationVBoxC/MenuElectronMarginC
@onready var ListeAmeliorationsNoyau = $PresentationVBoxC/MenuNoyauMarginC/AmeliorationsNoyauVBoxC/ContenuMarginC/AmeliorationsNoyauxHBoxC
@onready var ListeAmeliorationsElectronK = $PresentationVBoxC/MenuElectronMarginC/AmeliorationsElectronsVBoxC/ElectronsKMarginC/FondPanel/PresVBoxC/AmeliorationsElectronsKHBoxC
@onready var ListeAmeliorationsElectronL = $PresentationVBoxC/MenuElectronMarginC/AmeliorationsElectronsVBoxC/ElectronsLMarginC/FondPanel/PresVBoxC/AmeliorationsElectronsLHBoxC

@onready var QuantiteeLithium = $PresentationVBoxC/TopMarginC/TopHBoxC/GUIMarginC

@onready var BonusProtonLabel = $PresentationVBoxC/MiddleMarginC/RecapHBoxC/VBoxContainer/BonusProtonHBoxC/BonusLabel
@onready var BonusNeutronLabel = $PresentationVBoxC/MiddleMarginC/RecapHBoxC/VBoxContainer/BonusNeutronHBoxC/BonusLabel

var CustomCanvasAmeliorationNoyauLithium = preload("res://Design/Scenes/Ameliorations/CanvasAmelioLithiumNoyau.tscn")
var CustomButtonAmeliorationElectronLithium = preload("res://Design/Scenes/Ameliorations/ButtonAmeliorationLithium.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	RechercheClick.connect("AmeliorationLithium_button_pressed", AchatAmeliorationLithiumButtonPressed)
	
	QuantiteeLithium._set_var("Lithium", Big.new(0.0))
	
	for ameliorationLithium in RessourceManager.ListeAmeliorationsLithium:
		match ameliorationLithium.CategorieAmeliorationLithium:
			AmeliorationLithium.CategorieAmeliorationLithiumEnum.Proton:
				var newAmeliorationLithiumCanvas = CustomCanvasAmeliorationNoyauLithium.instantiate()
				newAmeliorationLithiumCanvas._set_var(ameliorationLithium)
				ListeAmeliorationsNoyau.add_child(newAmeliorationLithiumCanvas)
			AmeliorationLithium.CategorieAmeliorationLithiumEnum.Neutron:
				var newAmeliorationLithiumCanvas = CustomCanvasAmeliorationNoyauLithium.instantiate()
				newAmeliorationLithiumCanvas._set_var(ameliorationLithium)
				ListeAmeliorationsNoyau.add_child(newAmeliorationLithiumCanvas)
			AmeliorationLithium.CategorieAmeliorationLithiumEnum.ElectronK:
				var newAmeliorationElectronLithiumButton = CustomButtonAmeliorationElectronLithium.instantiate()
				newAmeliorationElectronLithiumButton._set_var(ameliorationLithium)
				ListeAmeliorationsElectronK.add_child(newAmeliorationElectronLithiumButton)
			AmeliorationLithium.CategorieAmeliorationLithiumEnum.ElectronL:
				var newAmeliorationElectronLithiumButton = CustomButtonAmeliorationElectronLithium.instantiate()
				newAmeliorationElectronLithiumButton._set_var(ameliorationLithium)
				ListeAmeliorationsElectronL.add_child(newAmeliorationElectronLithiumButton)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	BonusProtonLabel.text = "+" + str(Big.multiply(BonusManager.GetAmeliorationLithiumCoefficientProtonAvecNiveau(), Big.new(1.0, 2))) + "%"
	BonusNeutronLabel.text = "+/" + str(BonusManager.GetAmeliorationLithiumCoefficientNeutronAvecNiveau())


#Trigger lors de l'appuie sur un bouton pour augmenter une amélioration de lithium
func AchatAmeliorationLithiumButtonPressed(ameliorationLithium:AmeliorationLithium):
	if ameliorationLithium.GetPrixAmeliorationLithium().isLessThanOrEqualTo(RessourceManager.QuantiteesAtomes["Lithium"]):
		RessourceManager.QuantiteesAtomes["Lithium"] = Big.subtractAbove0(RessourceManager.QuantiteesAtomes["Lithium"], ameliorationLithium.GetPrixAmeliorationLithium())
		ameliorationLithium.Level = Big.add(ameliorationLithium.Level, Big.new(1.0))
		
		BonusManager.MajBonusAmeliorationLithium()


#Trigger lors de l'appuie sur le bouton exit
func _on_button_exit_pressed():
	hide()
