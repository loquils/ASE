extends Control

func _ready():
	pass


func _process(_delta):
	$WindowTopBlackVBoxC/MarginContainer/MainVBoxC/TopHBoxC/RessourcesVBoxC/CoinsHBoxC/Coins.text = str(RessourceManager.Coins)
	#var prix = round(coin.PrixBaseAmelioAttributs["Force"] * pow(coin.CoefficientsAchatAttributs["Force"], coin.NiveauxAttributs["Force"]))

	#Maj Ui vente
	var PrixVenteHydrogene = RessourceManager.ListeAtomes["Hydrogene"].PrixBaseVenteAtome.multiply(CustomNumber.new(1.0 + $WindowTopBlackVBoxC/MarginContainer/MainVBoxC/MenuAllGame/MenuRecherche.CurrentBonusesResearches["PrixHydrogenePerCent"]))
	$WindowTopBlackVBoxC/MarginContainer/MainVBoxC/TopHBoxC/VBoxBoutons/VBoxVente/ValeurHydrogeneLabel.text = str(PrixVenteHydrogene) + "/H"
	$WindowTopBlackVBoxC/MarginContainer/MainVBoxC/TopHBoxC/VBoxBoutons/VBoxVente/ValeurVenteLabel.text = str(PrixVenteHydrogene.multiply(RessourceManager.QuantiteesAtomes["Hydrogene"])) + "coins !"


func GetPrixVenteHydrogene():
	var newPrix = RessourceManager.ListeAtomes["Hydrogene"].PrixBaseVenteAtome.multiply(RessourceManager.CurrentBonusesAmeliorationHelium["HydrogeneRendementMultiply"])


func _on_bouton_menu_pressed():
	$WindowTopBlackVBoxC/MarginContainer/MainVBoxC/MenuAllGame.visible = !$WindowTopBlackVBoxC/MarginContainer/MainVBoxC/MenuAllGame.visible


func _on_main_timer_timeout():
	for atome in RessourceManager.ListeAtomes:
		if RessourceManager.ListeAtomes[atome].isUnlocked:
			RessourceManager.QuantiteesAtomes[atome] = RessourceManager.QuantiteesAtomes[atome].add(RessourceManager.ListeAtomes[atome].GetAtomePerSec())



func _on_button_vendre_pressed():
	var PrixVenteHydrogene = RessourceManager.ListeAtomes["Hydrogene"].PrixBaseVenteAtome.multiply(CustomNumber.new(1.0).add(CustomNumber.new($WindowTopBlackVBoxC/MarginContainer/MainVBoxC/MenuAllGame/MenuRecherche.CurrentBonusesResearches["PrixHydrogenePerCent"])))
	RessourceManager.Coins = RessourceManager.Coins.add(PrixVenteHydrogene.multiply(RessourceManager.QuantiteesAtomes["Hydrogene"]))
	RessourceManager.QuantiteesAtomes["Hydrogene"] = CustomNumber.new()
	RessourceManager.Coins.prints()


func _on_button_pressed():
	Save.save_game()
