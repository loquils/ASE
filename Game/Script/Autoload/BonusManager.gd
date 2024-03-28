extends Node

var CurrentBonusesResearches = {"PrixHydrogeneAugmentation" : Big.new(0.0)}

#Amélioration de l'helium
var BonusTypesAmeliorationHelium = ["HydrogeneRendementMultiply", "HydrogeneAttributsCoefficientAdd"]
var CurrentBonusesAmeliorationHelium = {}


func _ready():
	for bonusType in BonusTypesAmeliorationHelium:
		CurrentBonusesAmeliorationHelium[bonusType] = Big.new(0.0)


#Permet de mettre à jour le dictionnaire des ressources
#On parcour la liste des ressources, et on ajoute les bonus
func MajBonusRecherches():
	CurrentBonusesResearches["PrixHydrogeneAugmentation"] = Big.new(0.0)
	for recherche in RessourceManager.ListeRecherches:
		if recherche.IsUnlocked:
			match recherche.Augmentation:
				"PrixHydrogeneAugmentation":
					CurrentBonusesResearches[recherche.Augmentation] = Big.add(CurrentBonusesResearches[recherche.Augmentation], recherche.AugmentationPercent)



#Mise à jour des bonus des améliorations de l'Helium
func MajBonusAmeliorationHelium():
	RessourceManager.AtomsList["Hydrogene"].GlobalMultiplicator = Big.new(1.0)
	
	for CurrentBonus in CurrentBonusesAmeliorationHelium:
		CurrentBonusesAmeliorationHelium[CurrentBonus] = Big.new(1.0)
	
	for ameliorationHelium in RessourceManager.ListeAmeliorationsHelium:
		if ameliorationHelium.IsUnlocked:
			CurrentBonusesAmeliorationHelium[ameliorationHelium.BonusTypeAmeliorationHelium] = Big.add(CurrentBonusesAmeliorationHelium[ameliorationHelium.BonusTypeAmeliorationHelium], Big.multiply(ameliorationHelium.BonusAmeliorationHelium, ameliorationHelium.Level))
	
	for CurrentBonus in CurrentBonusesAmeliorationHelium:
		match CurrentBonus:
			"HydrogeneRendementMultiply":
				if CurrentBonusesAmeliorationHelium[CurrentBonus].isEqualTo(Big.new(0.0)):
					RessourceManager.AtomsList["Hydrogene"].ApportAtome = RessourceManager.AtomsList["Hydrogene"].ApportAtomeBase
				else:
					RessourceManager.AtomsList["Hydrogene"].GlobalMultiplicator = Big.multiply(RessourceManager.AtomsList["Hydrogene"].GlobalMultiplicator, CurrentBonusesAmeliorationHelium[CurrentBonus])

			"HydrogeneAttributsCoefficientAdd":
				for attributHydrogene in RessourceManager.AtomsList["Hydrogene"].ListeAttribs:
					attributHydrogene.CoefficientRapport = Big.add(attributHydrogene.CoefficientBaseRapport, BonusManager.CurrentBonusesAmeliorationHelium[CurrentBonus])


func GetGlobalMultiplicator(Name):
	var globalMultiplicator = Big.new(1.0)
	
	for CurrentBonus in CurrentBonusesAmeliorationHelium:
		if CurrentBonus.contains(Name) and CurrentBonus.contains("RendementMultiply"):
			globalMultiplicator = Big.multiply(globalMultiplicator, CurrentBonusesAmeliorationHelium[CurrentBonus])
	
	return globalMultiplicator
