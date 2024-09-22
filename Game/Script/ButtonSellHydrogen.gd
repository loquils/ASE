extends Button

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var PrixVenteHydrogene = Big.multiply(RessourceManager.ListeAtomes["Hydrogene"].PrixBaseVenteAtome, Big.add(Big.new(1.0), BonusManager.CurrentBonusesRecherches["PrixHydrogeneAugmentation"]))
	if RessourceManager.QuantiteesAtomes.has("Hydrogene"):
		$PanelC/PresentationVBoxC/MarginC2/PriceLabel.text = str(Big.multiply(PrixVenteHydrogene, RessourceManager.QuantiteesAtomes["Hydrogene"])) + " C"
	else:
		$PanelC/PresentationVBoxC/MarginC2/PriceLabel.text = "0 C"

func _on_pressed():
	var PrixVenteHydrogene = Big.multiply(RessourceManager.ListeAtomes["Hydrogene"].PrixBaseVenteAtome, Big.add(Big.new(1.0), BonusManager.CurrentBonusesRecherches["PrixHydrogeneAugmentation"]))
	var coinsToAdd = Big.add(RessourceManager.Coins, Big.multiply(PrixVenteHydrogene, RessourceManager.QuantiteesAtomes["Hydrogene"]))
	InfosPartie.CoinsObtenusInThisReset = Big.add(InfosPartie.CoinsObtenusInThisReset, coinsToAdd)
	RessourceManager.Coins = coinsToAdd
	RessourceManager.QuantiteesAtomes["Hydrogene"] = Big.new(0.0)
