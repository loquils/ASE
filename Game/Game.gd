extends Control

var ListeAtomes

func _ready():
	ListeAtomes = {"Hydrogene" : Atome.new("Hydrogene")}



func _process(_delta):
	var coin = ListeAtomes["Hydrogene"]
	$ParticulesContainer/HBoxContainer/Coins.text = str(RessourceManager.Coins)
	$ParticulesContainer/HBoxContainer2/Hydrogene.text = str(RessourceManager.QuantiteesAtomes["Hydrogene"])
	
	$ParticulesContainer/HBoxContainer2/HydrogeneParSec.text = str(coin.ApportAtome * (1 + coin.AugmentationHydroForce + coin.AugmentationHydroVitesse)) + "/s"
	
	#Maj button amelio force
	$MenuAllGame/MenuAtomes/Panel/HBoxContainer/AmelioForce/VBoxContainer/Niveau.text = str(coin.NiveauxAttributs["Force"])
	var prix = round(coin.PrixBaseAmelioAttributs["Force"] * pow(coin.CoefficientsAchatAttributs["Force"], coin.NiveauxAttributs["Force"]))
	$MenuAllGame/MenuAtomes/Panel/HBoxContainer/AmelioForce/VBoxContainer/Prix.text = str(prix)
	#Maj button amelio vitesse
	$MenuAllGame/MenuAtomes/Panel/HBoxContainer/AmelioVitesse/VBoxContainer/Niveau.text = str(coin.NiveauxAttributs["Vitesse"])
	var prixv = round(coin.PrixBaseAmelioAttributs["Vitesse"] * pow(coin.CoefficientsAchatAttributs["Vitesse"], coin.NiveauxAttributs["Vitesse"]))
	$MenuAllGame/MenuAtomes/Panel/HBoxContainer/AmelioVitesse/VBoxContainer/Prix.text = str(prixv)
	#Maj Ui vente
	var PrixVenteHydrogene = coin.PrixBaseVenteAtome * (1 + $MenuAllGame/MenuRecherche.CurrentBonusesResearches["PrixHydrogenePerCent"])
	$VBoxVente/ValeurHydrogeneLabel.text = str(PrixVenteHydrogene) + "/H"
	$VBoxVente/ValeurVenteLabel.text = str(PrixVenteHydrogene * RessourceManager.QuantiteesAtomes["Hydrogene"]) + "coins !"


func _on_bouton_menu_pressed():
	$MenuAllGame.visible = !$MenuAllGame.visible


func _on_main_timer_timeout():
	var coin = ListeAtomes["Hydrogene"]
	coin.AugmentationHydroForce = coin.CoefficientsRapportAttributs["Force"] * coin.NiveauxAttributs["Force"]
	coin.AugmentationHydroVitesse = coin.CoefficientsRapportAttributs["Vitesse"] * coin.NiveauxAttributs["Vitesse"]
	RessourceManager.QuantiteesAtomes["Hydrogene"] += round(coin.ApportAtome * (1 + coin.AugmentationHydroForce + coin.AugmentationHydroVitesse))
	


func _on_amelio_force_pressed():
	var coin = ListeAtomes["Hydrogene"]
	var prix = round(coin.PrixBaseAmelioAttributs["Force"] * pow(coin.CoefficientsAchatAttributs["Force"], coin.NiveauxAttributs["Force"]))
	if RessourceManager.Coins >= prix:
		RessourceManager.Coins -= prix
		coin.NiveauxAttributs["Force"] += 1


func _on_amelio_vitesse_pressed():
	var coin = ListeAtomes["Hydrogene"]
	var prix = round(coin.PrixBaseAmelioAttributs["Vitesse"] * pow(coin.CoefficientsAchatAttributs["Vitesse"], coin.NiveauxAttributs["Vitesse"]))
	if RessourceManager.Coins >= prix:
		RessourceManager.Coins -= prix
		coin.NiveauxAttributs["Vitesse"] += 1


func _on_button_vendre_pressed():
	var coin = ListeAtomes["Hydrogene"]
	var PrixVenteHydrogene = coin.PrixBaseVenteAtome * (1.0 + $MenuAllGame/MenuRecherche.CurrentBonusesResearches["PrixHydrogenePerCent"])
	RessourceManager.Coins += PrixVenteHydrogene * RessourceManager.QuantiteesAtomes["Hydrogene"]
	RessourceManager.QuantiteesAtomes["Hydrogene"] = 0
