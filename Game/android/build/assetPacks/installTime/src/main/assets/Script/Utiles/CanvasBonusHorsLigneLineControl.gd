extends Control

@onready var NameLabel = $HBoxC/NamePanelC/NameLabel
@onready var QuantityLabel = $HBoxC/QuantityPanelC2/QuantityLabel

var Name
var Quantity

#Permet de définir les variables à afficher.
func _set_vars(name, quantity):
	Name = name
	Quantity = quantity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	NameLabel.text = tr(Name)
	QuantityLabel.text = str(Quantity)
