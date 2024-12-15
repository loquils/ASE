extends Control

@onready var QuantiteeHydrogene = $MainPanelC/PresentationVBoxC/TopMarginC/VBoxC/TopHBoxC/HydrogeneGUIMarginC
@onready var QuantiteeCarbone = $MainPanelC/PresentationVBoxC/TopMarginC/VBoxC/TopHBoxC/CarboneGUIMarginC

@onready var AmeliorationAlcanes = $MainPanelC/PresentationVBoxC/ScrollC/VBoxC/AlcanesMarginC/AlcanesPanelC/VBoxC/ContentMarginC
@onready var AmeliorationAlcenes = $MainPanelC/PresentationVBoxC/ScrollC/VBoxC/AlcenesMarginC/AlcenesPanelC/VBoxC/ContentMarginC
@onready var AmeliorationAlcynes = $MainPanelC/PresentationVBoxC/ScrollC/VBoxC/AlcynesMarginC/AlcynesPanelC/VBoxC/ContentMarginC

var CustomCanvasAmeliorationCarbone = preload("res://Design/Scenes/Ameliorations/ButtonAmeliorationCarboneControl.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	QuantiteeHydrogene._set_var("Hydrogene", Big.new(0.0))
	QuantiteeCarbone._set_var("Carbone", Big.new(0.0))
	
	for ameliorationCarbone in RessourceManager.ListeAmeliorationsCarbone:
		var newAmeliorationCarboneCanvas = CustomCanvasAmeliorationCarbone.instantiate()
		newAmeliorationCarboneCanvas._set_var(ameliorationCarbone)
		match ameliorationCarbone.TypeAmeliorationCarbone:
			AmeliorationCarbone.TypeAmeliorationCarboneEnum.Alcane:
				AmeliorationAlcanes.add_child(newAmeliorationCarboneCanvas)
			AmeliorationCarbone.TypeAmeliorationCarboneEnum.Alcene:
				AmeliorationAlcenes.add_child(newAmeliorationCarboneCanvas)
			AmeliorationCarbone.TypeAmeliorationCarboneEnum.Alcyne:
				AmeliorationAlcynes.add_child(newAmeliorationCarboneCanvas)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#Trigger lors de l'appuie sur le bouton exit
func _on_button_exit_pressed():
	hide()
