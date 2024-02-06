extends Control

var Coins
var QuantiteesAtomes = {"Hydrogene" : 0}

#Hydrogene
var NiveauHydrogene
var CoefficientsRapportHydrogene
var CoefficientsAchatHydrogene
var PrixBaseAmelioHydrogene
var PrixVenteHydrogene

var ApportHydrogene

var AugmentationHydroForce
var AugmentationHydroVitesse

func _ready():
	Coins = 0
	PrixVenteHydrogene = 1
	NiveauHydrogene = {"Force" : 0, "Vitesse" : 0}
	
	ApportHydrogene = 1
	
	CoefficientsRapportHydrogene = {"Force" : 1.07, "Vitesse" : 1.10}
	CoefficientsAchatHydrogene = {"Force" : 1.2, "Vitesse" : 1.5}
	
	PrixBaseAmelioHydrogene = {"Force" : 5, "Vitesse" : 10}
	
	AugmentationHydroForce =  CoefficientsRapportHydrogene["Force"] * NiveauHydrogene["Force"]
	AugmentationHydroVitesse = CoefficientsRapportHydrogene["Vitesse"] * NiveauHydrogene["Vitesse"]

func _process(_delta):
	$ParticulesContainer/HBoxContainer/Coins.text = str(Coins)
	$ParticulesContainer/HBoxContainer2/Hydrogene.text = str(QuantiteesAtomes["Hydrogene"])
	
	$ParticulesContainer/HBoxContainer2/HydrogeneParSec.text = str(ApportHydrogene * (1 + AugmentationHydroForce + AugmentationHydroVitesse)) + "/s"
	
	#Maj button amelio force
	$MenuAllGame/MenuHydrogene/Panel/HBoxContainer/AmelioForce/VBoxContainer/Niveau.text = str(NiveauHydrogene["Force"])
	var prix = round(PrixBaseAmelioHydrogene["Force"] * pow(CoefficientsAchatHydrogene["Force"], NiveauHydrogene["Force"]))
	$MenuAllGame/MenuHydrogene/Panel/HBoxContainer/AmelioForce/VBoxContainer/Prix.text = str(prix)
	#Maj button amelio vitesse
	$MenuAllGame/MenuHydrogene/Panel/HBoxContainer/AmelioVitesse/VBoxContainer/Niveau.text = str(NiveauHydrogene["Vitesse"])
	var prixv = round(PrixBaseAmelioHydrogene["Vitesse"] * pow(CoefficientsAchatHydrogene["Vitesse"], NiveauHydrogene["Vitesse"]))
	$MenuAllGame/MenuHydrogene/Panel/HBoxContainer/AmelioVitesse/VBoxContainer/Prix.text = str(prixv)


func _on_bouton_menu_pressed():
	$MenuAllGame.visible = !$MenuAllGame.visible


func _on_main_timer_timeout():
	AugmentationHydroForce = CoefficientsRapportHydrogene["Force"] * NiveauHydrogene["Force"]
	AugmentationHydroVitesse = CoefficientsRapportHydrogene["Vitesse"] * NiveauHydrogene["Vitesse"]
	QuantiteesAtomes["Hydrogene"] += round(ApportHydrogene * (1 + AugmentationHydroForce + AugmentationHydroVitesse))


func _on_amelio_force_pressed():
	var prix = round(PrixBaseAmelioHydrogene["Force"] * pow(CoefficientsAchatHydrogene["Force"], NiveauHydrogene["Force"]))
	if Coins >= prix:
		Coins -= prix
		NiveauHydrogene["Force"] += 1


func _on_amelio_vitesse_pressed():
	var prix = round(PrixBaseAmelioHydrogene["Vitesse"] * pow(CoefficientsAchatHydrogene["Vitesse"], NiveauHydrogene["Vitesse"]))
	if Coins >= prix:
		Coins -= prix
		NiveauHydrogene["Vitesse"] += 1


func _on_button_vendre_pressed():
	Coins += round(PrixVenteHydrogene * QuantiteesAtomes["Hydrogene"])
	QuantiteesAtomes["Hydrogene"] = 0
