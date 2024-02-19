extends Control

func _ready():
	pass


func _process(_delta):
	$HBoxContainer/Coins.text = str(RessourceManager.Coins)
	#var prix = round(coin.PrixBaseAmelioAttributs["Force"] * pow(coin.CoefficientsAchatAttributs["Force"], coin.NiveauxAttributs["Force"]))

	#Maj Ui vente
	var PrixVenteHydrogene = RessourceManager.ListeAtomes["Hydrogene"].PrixBaseVenteAtome.multiply(CustomNumber.new(1.0 + $MenuAllGame/MenuRecherche.CurrentBonusesResearches["PrixHydrogenePerCent"]))
	$VBoxVente/ValeurHydrogeneLabel.text = str(PrixVenteHydrogene) + "/H"
	$VBoxVente/ValeurVenteLabel.text = str(PrixVenteHydrogene.multiply(RessourceManager.QuantiteesAtomes["Hydrogene"])) + "coins !"


func _on_bouton_menu_pressed():
	$MenuAllGame.visible = !$MenuAllGame.visible


func _on_main_timer_timeout():
	for atome in RessourceManager.ListeAtomes:
		if RessourceManager.ListeAtomes[atome].isUnlocked:
			RessourceManager.QuantiteesAtomes[atome] = RessourceManager.QuantiteesAtomes[atome].add(RessourceManager.ListeAtomes[atome].ApportAtome.multiply(CustomNumber.new(1.0).add(RessourceManager.ListeAtomes[atome].GetAugmentationsAttributs())))
	


#func _on_amelio_force_pressed():
#	var coin = ListeAtomes["Hydrogene"]
#	var prix = round(coin.PrixBaseAmelioAttributs["Force"] * pow(coin.CoefficientsAchatAttributs["Force"], coin.NiveauxAttributs["Force"]))
#	if RessourceManager.Coins >= prix:
#		RessourceManager.Coins -= prix
#		coin.NiveauxAttributs["Force"] += 1



func _on_button_vendre_pressed():
	var PrixVenteHydrogene = RessourceManager.ListeAtomes["Hydrogene"].PrixBaseVenteAtome.multiply(CustomNumber.new(1.0).add(CustomNumber.new($MenuAllGame/MenuRecherche.CurrentBonusesResearches["PrixHydrogenePerCent"])))
	RessourceManager.Coins = RessourceManager.Coins.add(PrixVenteHydrogene.multiply(RessourceManager.QuantiteesAtomes["Hydrogene"]))
	RessourceManager.QuantiteesAtomes["Hydrogene"] = CustomNumber.new()
	RessourceManager.Coins.prints()


func _on_button_pressed():
	print("---------------Soustraction--------------------")
	var number1 = CustomNumber.new(8.85341, 212122)
	number1.prints()
	var number2 = CustomNumber.new(1.56314, 212122)
	number2.prints()
	
	number1.minus(number2).prints()
	
	print("---------------Addition--------------------")
	var number3 = CustomNumber.new(1.25341, 23488)
	number3.prints()
	var number4 = CustomNumber.new(300.09733, 23485)
	number4.prints()
	
	number3.add(number4).prints()
	
	
	print("---------------NombresRandoms--------------------")
	var number5 = CustomNumber.new(1.25341, 0)
	number5.prints()
	
	var number6 = CustomNumber.new(3.0973, 5)
	number6.prints()
	
	var number7 = CustomNumber.new(3.0973, 6)
	number7.prints()

	print("---------------Multiplication--------------------")
	var number8 = CustomNumber.new(2.15486, 6)
	number8.prints()
	var number9 = CustomNumber.new(8.46575, 8)
	number9.prints()
	
	number8.multiply(number9).prints()

	print("---------------Power--------------------")
	var number10 = CustomNumber.new(3.12, 1048)
	number10.prints()
	var number11 = CustomNumber.new(2.0, 5)
	number11.prints()
	
	number10.power2(number11).prints()
