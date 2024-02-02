extends Control

var Coins
var QuantiteesAtomes = {"hydrogene" : 0}
var NiveauHydrogene
var CoefficientsHydrogene
var PrixHydrogene

func _ready():
	Coins = 0
	NiveauHydrogene = {"Force" : 0, "Vitesse" : 0}
	CoefficientsHydrogene = {"Force" : 0.15, "Vitesse" : 0.10}
	PrixHydrogene = {"Force" : [0,10,100,1000,10000], "Vitesse" : [0,10,100,1000,10000]}

func _process(_delta):
	$ParticulesContainer/HBoxContainer/Coins.text = str(Coins)
	$ParticulesContainer/HBoxContainer2/Hydrogene.text = str(QuantiteesAtomes["hydrogene"])

func _on_bouton_menu_pressed():
	$MenuAugmentation.visible = !$MenuAugmentation.visible

func _on_main_timer_timeout():
	QuantiteesAtomes["hydrogene"] += 1 + (NiveauHydrogene["Force"] * CoefficientsHydrogene["Force"]) + (NiveauHydrogene["Vitesse"] * CoefficientsHydrogene["Vitesse"])


func _on_amelio_force_pressed():
	pass # Replace with function body.
