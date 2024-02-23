extends Control


var CustomButtonAmeliorationHelium = preload("res://Design/Scenes/ButtonAmelioHelium.tscn")

#Amélioration de l'helium
var BonusTypesAmeliorationHelium = ["HydrogeneRendementMultiply", "HydrogeneAttributsCoefficientAdd"]
var CurrentBonusesAmeliorationHelium = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	RechercheClick.connect("AmeliorationHelium_button_pressed", AchatAmeliorationHeliumButtonPressed)

	for ameliorationHelium in RessourceManager.ListeAmeliorationsHelium:
		var newAmeliorationHeliumButton = CustomButtonAmeliorationHelium.instantiate()
		newAmeliorationHeliumButton._set_var(ameliorationHelium)
		match ameliorationHelium.TypeAmeliorationHelium:
			AmeliorationHelium.TypeAmeliorationHeliumEnum.Pression:
				$PresentationVBoxC/LeftVBoxC/ScrollC/ListeHeliumUpgradesVBoxC.add_child(newAmeliorationHeliumButton)
			AmeliorationHelium.TypeAmeliorationHeliumEnum.Temperature:
				$PresentationVBoxC/RightVBoxC/ScrollC/ListeHeliumUpgradesVBoxC.add_child(newAmeliorationHeliumButton)
	
	for bonusType in BonusTypesAmeliorationHelium:
		CurrentBonusesAmeliorationHelium[bonusType] = CustomNumber.new()
	
	MajBonusAmeliorationHelium()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		$DebugLabel.text = str(CurrentBonusesAmeliorationHelium[BonusTypesAmeliorationHelium[0]])


func MajBonusAmeliorationHelium():
	for CurrentBonus in CurrentBonusesAmeliorationHelium:
		CurrentBonusesAmeliorationHelium[CurrentBonus] = CustomNumber.new()
	
	for ameliorationHelium in RessourceManager.ListeAmeliorationsHelium:
		if ameliorationHelium.IsUnlocked:
			CurrentBonusesAmeliorationHelium[ameliorationHelium.BonusTypeAmeliorationHelium] = CurrentBonusesAmeliorationHelium[ameliorationHelium.BonusTypeAmeliorationHelium].add(ameliorationHelium.BonusAmeliorationHelium.multiply(ameliorationHelium.Level), true)
			
	for CurrentBonus in CurrentBonusesAmeliorationHelium:
		match CurrentBonus:
			"HydrogeneRendementMultiply":
				if CurrentBonusesAmeliorationHelium[CurrentBonus].compare(CustomNumber.new()) == 0:
					RessourceManager.ListeAtomes["Hydrogene"].ApportAtome = RessourceManager.ListeAtomes["Hydrogene"].ApportAtomeBase
				else:
					RessourceManager.ListeAtomes["Hydrogene"].ApportAtome = RessourceManager.ListeAtomes["Hydrogene"].ApportAtomeBase.multiply(CurrentBonusesAmeliorationHelium[CurrentBonus])
			"HydrogeneAttributsCoefficientAdd":
				for attributHydrogene in RessourceManager.ListeAtomes["Hydrogene"].ListeAttribs:
					attributHydrogene.CoefficientRapport = attributHydrogene.CoefficientBaseRapport.add(CurrentBonusesAmeliorationHelium[CurrentBonus])


#Trigger lors de l'appuie sur un bouton pour augmenter une amélioration de l'helium
func AchatAmeliorationHeliumButtonPressed(ameliorationHelium):
	if ameliorationHelium.GetPrixAmeliorationHelium().compare(RessourceManager.QuantiteesAtomes["Helium"]) <= 0:
		RessourceManager.QuantiteesAtomes["Helium"] = RessourceManager.QuantiteesAtomes["Helium"].minus(ameliorationHelium.GetPrixAmeliorationHelium())
		ameliorationHelium.Level = ameliorationHelium.Level.add(CustomNumber.new(1.0))
		print("Amélioration Helium " + ameliorationHelium.Name + " achetée ! Niveau : " + str(ameliorationHelium.Level))
		MajBonusAmeliorationHelium()
