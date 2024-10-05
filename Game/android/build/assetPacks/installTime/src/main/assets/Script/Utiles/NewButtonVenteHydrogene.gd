extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var PrixVenteHydrogene = Big.multiply(RessourceManager.ListeAtomes["Hydrogene"].PrixBaseVenteAtome, Big.add(Big.new(1.0), BonusManager.GetPrixHydrogene()))
	if RessourceManager.QuantiteesAtomes.has("Hydrogene"):
		$PresentationPanel/PresentationVBoxC/PrixMarginC/PanelC/MarginC/PrixLabel.text = str(Big.multiply(PrixVenteHydrogene, RessourceManager.QuantiteesAtomes["Hydrogene"])) + " C"
	else:
		$PresentationPanel/PresentationVBoxC/PrixMarginC/PanelC/MarginC/PrixLabel.text = "0 C"

func _on_pressed():
	var PrixVenteHydrogene = Big.multiply(RessourceManager.ListeAtomes["Hydrogene"].PrixBaseVenteAtome, Big.add(Big.new(1.0), BonusManager.GetPrixHydrogene()))
	var coinsToAdd = Big.add(RessourceManager.Coins, Big.multiply(PrixVenteHydrogene, RessourceManager.QuantiteesAtomes["Hydrogene"]))
	InfosPartie.CoinsObtenusInThisReset = Big.add(InfosPartie.CoinsObtenusInThisReset, coinsToAdd)
	RessourceManager.Coins = coinsToAdd
	RessourceManager.QuantiteesAtomes["Hydrogene"] = Big.new(0.0)
