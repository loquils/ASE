extends Control

var Atome
var AttributBoutton = preload("res://ButtonAttribut.tscn")

func _set_var(atome):
	Atome = atome
	
	$NomAtomeLabel.text = atome.Nom
	
	for attribut in atome.ListeAttribs:
		var newBouton = AttributBoutton.instantiate()
		newBouton._set_var(attribut)
		$HBoxContainer.add_child(newBouton)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
