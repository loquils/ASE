extends Control

var ListeAtomes

func _ready():
	#ListeAtomes = {"Hydrogene" : Atome.new("Hydrogene")}
	pass


func _process(_delta):
	ListeAtomes = $MenuAllGame/MenuAtomes.ListeAtomes
	$HBoxContainer/Coins.text = str(RessourceManager.Coins)
	$ParticulesContainer/HBoxContainer2/Hydrogene.text = str(RessourceManager.QuantiteesAtomes["Hydrogene"])
	$ParticulesContainer/HBoxContainer2/HydrogeneParSec.text = str(ListeAtomes["Hydrogene"].ApportAtome * (1.0 + ListeAtomes["Hydrogene"].GetAugmentationsAttributs())) + "/s"
	
	$ParticulesContainer/HBoxContainer3/Helium.text = str(RessourceManager.QuantiteesAtomes["Helium"])
	if not ListeAtomes["Helium"].isUnlocked:
		$ParticulesContainer/HBoxContainer3/HeliumParSec.text = "0.00/s"
	$ParticulesContainer/HBoxContainer3/HeliumParSec.text = str(ListeAtomes["Helium"].ApportAtome * (1.0 + ListeAtomes["Helium"].GetAugmentationsAttributs())) + "/s"
	
	#Maj button amelio force
	#$MenuAllGame/MenuAtomes/Panel/HBoxContainer/AmelioForce/VBoxContainer/Niveau.text = str(coin.NiveauxAttributs["Force"])
	#var prix = round(coin.PrixBaseAmelioAttributs["Force"] * pow(coin.CoefficientsAchatAttributs["Force"], coin.NiveauxAttributs["Force"]))
	#$MenuAllGame/MenuAtomes/Panel/HBoxContainer/AmelioForce/VBoxContainer/Prix.text = str(prix)
	
	#Maj Ui vente
	var PrixVenteHydrogene = ListeAtomes["Hydrogene"].PrixBaseVenteAtome * (1.0 + $MenuAllGame/MenuRecherche.CurrentBonusesResearches["PrixHydrogenePerCent"])
	$VBoxVente/ValeurHydrogeneLabel.text = str(PrixVenteHydrogene) + "/H"
	$VBoxVente/ValeurVenteLabel.text = str(PrixVenteHydrogene * RessourceManager.QuantiteesAtomes["Hydrogene"]) + "coins !"


func _on_bouton_menu_pressed():
	$MenuAllGame.visible = !$MenuAllGame.visible


func _on_main_timer_timeout():
	for atome in ListeAtomes:
		if ListeAtomes[atome].isUnlocked:
			RessourceManager.QuantiteesAtomes[atome] += round(ListeAtomes[atome].ApportAtome * (1 + ListeAtomes[atome].GetAugmentationsAttributs()))
	


#func _on_amelio_force_pressed():
#	var coin = ListeAtomes["Hydrogene"]
#	var prix = round(coin.PrixBaseAmelioAttributs["Force"] * pow(coin.CoefficientsAchatAttributs["Force"], coin.NiveauxAttributs["Force"]))
#	if RessourceManager.Coins >= prix:
#		RessourceManager.Coins -= prix
#		coin.NiveauxAttributs["Force"] += 1



func _on_button_vendre_pressed():
	var PrixVenteHydrogene = ListeAtomes["Hydrogene"].PrixBaseVenteAtome * (1.0 + $MenuAllGame/MenuRecherche.CurrentBonusesResearches["PrixHydrogenePerCent"])
	RessourceManager.Coins += PrixVenteHydrogene * RessourceManager.QuantiteesAtomes["Hydrogene"]
	RessourceManager.QuantiteesAtomes["Hydrogene"] = 0
