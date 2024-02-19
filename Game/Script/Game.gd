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
	Save.save_game()
