extends Control

var Molecule:Molecule

@onready var NomLabel = $PanelC/MainVBoxC/NomMarginC/NomLabel

#Définition de l'UI du canvas.
func _set_var(molecule:Molecule):
	Molecule = molecule

func _process(_delta):
	NomLabel.text = tr(Molecule.Name)
