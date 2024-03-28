extends Button

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var PrixVenteHydrogene = Big.multiply(RessourceManager.AtomsList["Hydrogene"].PrixBaseVenteAtome, Big.add(Big.new(1.0), BonusManager.CurrentBonusesResearches["PrixHydrogeneAugmentation"]))
	$PanelC/PresentationVBoxC/MarginC2/PriceLabel.text = str(Big.multiply(PrixVenteHydrogene, RessourceManager.QuantiteesAtomes["Hydrogene"])) + " C"


func _on_pressed():
	var PrixVenteHydrogene = Big.multiply(RessourceManager.AtomsList["Hydrogene"].PrixBaseVenteAtome, Big.add(Big.new(1.0), BonusManager.CurrentBonusesResearches["PrixHydrogeneAugmentation"]))
	RessourceManager.Coins = Big.add(RessourceManager.Coins, Big.multiply(PrixVenteHydrogene, RessourceManager.QuantiteesAtomes["Hydrogene"]))
	RessourceManager.QuantiteesAtomes["Hydrogene"] = Big.new(0.0)
