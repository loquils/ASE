extends Node

var CurrentBonusesResearches = {"PrixHydrogeneAugmentation" : CustomNumber.new()}

#Amélioration de l'helium
var BonusTypesAmeliorationHelium = ["HydrogeneRendementMultiply", "HydrogeneAttributsCoefficientAdd"]
var CurrentBonusesAmeliorationHelium = {}


func _ready():
	for bonusType in BonusTypesAmeliorationHelium:
		CurrentBonusesAmeliorationHelium[bonusType] = CustomNumber.new()


#Permet de mettre à jour le dictionnaire des ressources
#On parcour la liste des ressources, et on ajoute les bonus
func MajBonusRecherches():
	CurrentBonusesResearches["PrixHydrogeneAugmentation"] = CustomNumber.new()
	for recherche in RessourceManager.ListeRecherches:
		if recherche.IsUnlocked:
			match recherche.Augmentation:
				"PrixHydrogeneAugmentation":
					CurrentBonusesResearches[recherche.Augmentation] = CurrentBonusesResearches[recherche.Augmentation].add(recherche.AugmentationPercent)



#Mise à jour des bonus des améliorations de l'Helium
func MajBonusAmeliorationHelium():
	RessourceManager.ListeAtomes["Hydrogene"].GlobalMultiplicator = CustomNumber.new(1.0)
	
	for CurrentBonus in CurrentBonusesAmeliorationHelium:
		CurrentBonusesAmeliorationHelium[CurrentBonus] = CustomNumber.new()
	
	for ameliorationHelium in RessourceManager.ListeAmeliorationsHelium:
		if ameliorationHelium.IsUnlocked:
			CurrentBonusesAmeliorationHelium[ameliorationHelium.BonusTypeAmeliorationHelium] = CurrentBonusesAmeliorationHelium[ameliorationHelium.BonusTypeAmeliorationHelium].add(ameliorationHelium.BonusAmeliorationHelium.multiply(ameliorationHelium.Level))
	
	for CurrentBonus in CurrentBonusesAmeliorationHelium:
		match CurrentBonus:
			"HydrogeneRendementMultiply":
				if CurrentBonusesAmeliorationHelium[CurrentBonus].compare(CustomNumber.new()) == 0:
					RessourceManager.ListeAtomes["Hydrogene"].ApportAtome = RessourceManager.ListeAtomes["Hydrogene"].ApportAtomeBase
				else:
					print("GlobalMultiplicator before : " + str(RessourceManager.ListeAtomes["Hydrogene"].GlobalMultiplicator))
					RessourceManager.ListeAtomes["Hydrogene"].GlobalMultiplicator = RessourceManager.ListeAtomes["Hydrogene"].GlobalMultiplicator.multiply(CurrentBonusesAmeliorationHelium[CurrentBonus])
					print("GlobalMultiplicator after : " + str(RessourceManager.ListeAtomes["Hydrogene"].GlobalMultiplicator))
			"HydrogeneAttributsCoefficientAdd":
				for attributHydrogene in RessourceManager.ListeAtomes["Hydrogene"].ListeAttribs:
					attributHydrogene.CoefficientRapport = attributHydrogene.CoefficientBaseRapport.add(BonusManager.CurrentBonusesAmeliorationHelium[CurrentBonus])
