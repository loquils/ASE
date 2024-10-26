extends Control

var CanvasMoleculePreload = preload("res://Design/Scenes/MatiereNoire/CanvasMoleculeControl.tscn")

@onready var ListeMoleculesVBoxC = $MainMarginC/VBoxContainer/ScrollC/ListeMoleculesVBoxC

# Called when the node enters the scene tree for the first time.
func _ready():
	for molecule in RessourceManager.ListeMolecules:
		var newMoleculeCanvas = CanvasMoleculePreload.instantiate()
		newMoleculeCanvas._set_var(molecule)
		ListeMoleculesVBoxC.add_child(newMoleculeCanvas)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
