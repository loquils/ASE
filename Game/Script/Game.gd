extends Control

func _ready():
	pass


func _process(_delta):
	$HBoxContainer/Coins.text = str(RessourceManager.Coins)

	#Maj button amelio force
	#$MenuAllGame/MenuAtomes/Panel/HBoxContainer/AmelioForce/VBoxContainer/Niveau.text = str(coin.NiveauxAttributs["Force"])
	#var prix = round(coin.PrixBaseAmelioAttributs["Force"] * pow(coin.CoefficientsAchatAttributs["Force"], coin.NiveauxAttributs["Force"]))
	#$MenuAllGame/MenuAtomes/Panel/HBoxContainer/AmelioForce/VBoxContainer/Prix.text = str(prix)
	
	#Maj Ui vente
	var PrixVenteHydrogene = RessourceManager.ListeAtomes["Hydrogene"].PrixBaseVenteAtome * (1.0 + $MenuAllGame/MenuRecherche.CurrentBonusesResearches["PrixHydrogenePerCent"])
	$VBoxVente/ValeurHydrogeneLabel.text = str(PrixVenteHydrogene) + "/H"
	$VBoxVente/ValeurVenteLabel.text = str(PrixVenteHydrogene * RessourceManager.QuantiteesAtomes["Hydrogene"]) + "coins !"


func _on_bouton_menu_pressed():
	$MenuAllGame.visible = !$MenuAllGame.visible


func _on_main_timer_timeout():
	for atome in RessourceManager.ListeAtomes:
		if RessourceManager.ListeAtomes[atome].isUnlocked:
			RessourceManager.QuantiteesAtomes[atome] += round(RessourceManager.ListeAtomes[atome].ApportAtome * (1 + RessourceManager.ListeAtomes[atome].GetAugmentationsAttributs()))
	


#func _on_amelio_force_pressed():
#	var coin = ListeAtomes["Hydrogene"]
#	var prix = round(coin.PrixBaseAmelioAttributs["Force"] * pow(coin.CoefficientsAchatAttributs["Force"], coin.NiveauxAttributs["Force"]))
#	if RessourceManager.Coins >= prix:
#		RessourceManager.Coins -= prix
#		coin.NiveauxAttributs["Force"] += 1



func _on_button_vendre_pressed():
	var PrixVenteHydrogene = RessourceManager.ListeAtomes["Hydrogene"].PrixBaseVenteAtome * (1.0 + $MenuAllGame/MenuRecherche.CurrentBonusesResearches["PrixHydrogenePerCent"])
	RessourceManager.Coins += PrixVenteHydrogene * RessourceManager.QuantiteesAtomes["Hydrogene"]
	RessourceManager.QuantiteesAtomes["Hydrogene"] = 0


func _on_button_pressed():
	print("---------------Soustraction--------------------")
	var number1 = CustomNumber.new(1.56314, 23)
	number1.prints()
	var number2 = CustomNumber.new(8.85341, 22)
	number2.prints()
	
	number1.minus(number2);
	
	number1.prints()
	
	print("---------------Addition--------------------")
	var number3 = CustomNumber.new(1.25341, 23)
	number3.prints()
	var number4 = CustomNumber.new(300.09733, 23)
	number4.prints()
	
	number3.add(number4)
	
	number3.prints()
	
	print("---------------NombresRandoms--------------------")
	var number5 = CustomNumber.new(1.25341, 0)
	number5.prints()
	
	var number6 = CustomNumber.new(3.0973, 5)
	number6.prints()
	
	var number7 = CustomNumber.new(3.0973, 6)
	number7.prints()
