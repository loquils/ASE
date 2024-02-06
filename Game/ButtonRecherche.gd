extends Button

var Recherche

func _set_var(recherche):
	Recherche = recherche
	$VBoxContainer/NomLabel.text = Recherche.Nom
	$VBoxContainer/DescriptionLabel.text = Recherche.Description
	$VBoxContainer/PrixLabel.text = str(Recherche.Prix)
