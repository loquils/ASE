extends Control

var ListeRecherches = []
var but = preload("res://ButtonRecherche.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	ListeRecherches.append(Recherche.new(0, "Coin", "Coiiiiiiiiiiiiiiiiiiiiiiiiiiin !!!", 1000))
	ListeRecherches.append(Recherche.new(0, "Coin", "Coiiiiiiiiiiiiiiiiiiiiiiiiiiin !!!", 1000))
	ListeRecherches.append(Recherche.new(0, "Coin", "Coiiiiiiiiiiiiiiiiiiiiiiiiiiin !!!", 1000))
	ListeRecherches.append(Recherche.new(0, "Coin", "Coiiiiiiiiiiiiiiiiiiiiiiiiiiin !!!", 1000))
	ListeRecherches.append(Recherche.new(0, "Coin", "Coiiiiiiiiiiiiiiiiiiiiiiiiiiin !!!", 1000))
	ListeRecherches.append(Recherche.new(0, "Coin", "Coiiiiiiiiiiiiiiiiiiiiiiiiiiin !!!", 1000))
	ListeRecherches.append(Recherche.new(0, "Coin", "Coiiiiiiiiiiiiiiiiiiiiiiiiiiin !!!", 1000))
	ListeRecherches.append(Recherche.new(0, "Coin", "Coiiiiiiiiiiiiiiiiiiiiiiiiiiin !!!", 1000))
	
	
	for recherche in ListeRecherches:
		var newRecherchebutton = but.instantiate()
		newRecherchebutton._set_var(recherche)
		$ScrollContainer/HBoxContainer.add_child(newRecherchebutton)
