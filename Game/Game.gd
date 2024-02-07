extends Control

var QuantiteesAtomes = {"Hydrogene" : 0}

#Hydrogene
var NiveauHydrogene
var CoefficientsRapportHydrogene
var CoefficientsAchatHydrogene
var PrixBaseAmelioHydrogene
var PrixBaseVenteHydrogene

var ApportHydrogene

var AugmentationHydroForce
var AugmentationHydroVitesse


func _ready():
	PrixBaseVenteHydrogene = 1
	NiveauHydrogene = {"Force" : 0, "Vitesse" : 0}
	
	ApportHydrogene = 1
	
	CoefficientsRapportHydrogene = {"Force" : 1.07, "Vitesse" : 1.10}
	CoefficientsAchatHydrogene = {"Force" : 1.2, "Vitesse" : 1.5}
	
	PrixBaseAmelioHydrogene = {"Force" : 5, "Vitesse" : 10}
	
	AugmentationHydroForce =  CoefficientsRapportHydrogene["Force"] * NiveauHydrogene["Force"]
	AugmentationHydroVitesse = CoefficientsRapportHydrogene["Vitesse"] * NiveauHydrogene["Vitesse"]

func recherche_pressed(recherche):
	print(recherche.Nom)

func _process(_delta):
	$ParticulesContainer/HBoxContainer/Coins.text = str(RessourceManager.Coins)
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
	#Maj Ui vente
	var PrixVenteHydrogene = PrixBaseVenteHydrogene * (1 + $MenuAllGame/MenuRecherche.CurrentBonusesResearches["PrixHydrogenePerCent"])
	$VBoxVente/ValeurHydrogeneLabel.text = str(PrixVenteHydrogene) + "/H"
	$VBoxVente/ValeurVenteLabel.text = str(PrixVenteHydrogene * QuantiteesAtomes["Hydrogene"]) + "coins !"


func _on_bouton_menu_pressed():
	$MenuAllGame.visible = !$MenuAllGame.visible


func _on_main_timer_timeout():
	AugmentationHydroForce = CoefficientsRapportHydrogene["Force"] * NiveauHydrogene["Force"]
	AugmentationHydroVitesse = CoefficientsRapportHydrogene["Vitesse"] * NiveauHydrogene["Vitesse"]
	QuantiteesAtomes["Hydrogene"] += round(ApportHydrogene * (1 + AugmentationHydroForce + AugmentationHydroVitesse))
	


func _on_amelio_force_pressed():
	var prix = round(PrixBaseAmelioHydrogene["Force"] * pow(CoefficientsAchatHydrogene["Force"], NiveauHydrogene["Force"]))
	if RessourceManager.Coins >= prix:
		RessourceManager.Coins -= prix
		NiveauHydrogene["Force"] += 1


func _on_amelio_vitesse_pressed():
	var prix = round(PrixBaseAmelioHydrogene["Vitesse"] * pow(CoefficientsAchatHydrogene["Vitesse"], NiveauHydrogene["Vitesse"]))
	if RessourceManager.Coins >= prix:
		RessourceManager.Coins -= prix
		NiveauHydrogene["Vitesse"] += 1


func _on_button_vendre_pressed():
	var PrixVenteHydrogene = PrixBaseVenteHydrogene * (1 + $MenuAllGame/MenuRecherche.CurrentBonusesResearches["PrixHydrogenePerCent"])
	RessourceManager.Coins += round(PrixVenteHydrogene * QuantiteesAtomes["Hydrogene"])
	QuantiteesAtomes["Hydrogene"] = 0
