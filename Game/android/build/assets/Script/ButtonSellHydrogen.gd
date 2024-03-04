extends Button

@export var MenuRecherche : Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var PrixVenteHydrogene = RessourceManager.ListeAtomes["Hydrogene"].PrixBaseVenteAtome.multiply(CustomNumber.new(1.0 + MenuRecherche.CurrentBonusesResearches["PrixHydrogenePerCent"]))
	$PanelC/PresentationVBoxC/MarginC2/PriceLabel.text = str(PrixVenteHydrogene.multiply(RessourceManager.QuantiteesAtomes["Hydrogene"])) + " C"


func _on_pressed():
	var PrixVenteHydrogene = RessourceManager.ListeAtomes["Hydrogene"].PrixBaseVenteAtome.multiply(CustomNumber.new(1.0).add(CustomNumber.new(MenuRecherche.CurrentBonusesResearches["PrixHydrogenePerCent"])))
	RessourceManager.Coins = RessourceManager.Coins.add(PrixVenteHydrogene.multiply(RessourceManager.QuantiteesAtomes["Hydrogene"]))
	RessourceManager.QuantiteesAtomes["Hydrogene"] = CustomNumber.new()
