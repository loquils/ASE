extends Control

var AmeliorationCarbone: AmeliorationCarbone

@onready var NameLabel = $MainPanelC/MainMarginC/MainVBoxC/TopHBoxC/LeftMarginC/AlcaneVBoxC/NomAlcaneLabel
@onready var QuantiteeLabel = $MainPanelC/MainMarginC/MainVBoxC/TopHBoxC/LeftMarginC/AlcaneVBoxC/QuantiteeHBoxC/QuantiteLabel

#Permet de définir l'amélioration associée à ce Canvas.
func _set_var(ameliorationCarbone:AmeliorationCarbone):
	AmeliorationCarbone = ameliorationCarbone

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	NameLabel.text = AmeliorationCarbone.GetNomMolecule()
	QuantiteeLabel.text = str(RessourceManager.QuantiteesMolecules[AmeliorationCarbone.GetNomMolecule().to_upper()])


func _on_dark_matter_upgrade_button_pressed():
	AmeliorationCarbone.UpgradeEtatMolecule()
