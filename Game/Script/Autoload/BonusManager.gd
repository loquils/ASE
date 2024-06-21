extends Node

#Bonus des Recherches
var CurrentBonusesResearches = {"PrixHydrogeneAugmentation" : Big.new(0.0), "HydrogeneCoeffMultiplicateurRapport" : Big.new(1.0), "HeliumCoeffMultiplicateurRapport" : Big.new(1.0)}
var BonusTypesRecherches = ["PrixHydrogeneAugmentation", "HydrogeneCoeffMultiplicateurRapport", "HeliumCoeffMultiplicateurRapport"]

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
	CurrentBonusesResearches["HydrogeneCoeffMultiplicateurRapport"] = Big.new(0.0)
	CurrentBonusesResearches["HeliumCoeffMultiplicateurRapport"] = Big.new(0.0)
	for recherche in RessourceManager.ListeRecherches:
		if recherche.IsUnlocked:
			CurrentBonusesResearches[recherche.Augmentation] = Big.add(CurrentBonusesResearches[recherche.Augmentation], recherche.AugmentationPercent)


#Mise à jour des bonus des améliorations de l'Helium
func MajBonusAmeliorationHelium():
	RessourceManager.AtomsList["Hydrogene"].GlobalMultiplicator = Big.new(1.0)
	
	for CurrentBonus in CurrentBonusesAmeliorationHelium:
		CurrentBonusesAmeliorationHelium[CurrentBonus] = Big.new(0.0)
	
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



#Permet de récupérer le multiplicateur global du rendu des atomes (prend en compte les recherches et les amélioration Helium
func GetGlobalMultiplicator(Name):
	var recherchesMultiplicator = Big.new(0.0)
	var heliumMultiplicator = Big.new(0.0)
	
	for CurrentResearchBonus in CurrentBonusesResearches:
		if CurrentResearchBonus.contains(Name) and CurrentResearchBonus.contains("CoeffMultiplicateurRapport"):
			recherchesMultiplicator = Big.add(recherchesMultiplicator, CurrentBonusesResearches[CurrentResearchBonus])
	
	for CurrentBonus in CurrentBonusesAmeliorationHelium:
		if CurrentBonus.contains(Name) and CurrentBonus.contains("RendementMultiply"):
			heliumMultiplicator = Big.add(heliumMultiplicator, CurrentBonusesAmeliorationHelium[CurrentBonus])
	
	var globalMultiplicator = Big.add(recherchesMultiplicator, heliumMultiplicator)
	
	if(globalMultiplicator.isEqualTo(Big.new(0.0))):
		globalMultiplicator = Big.new(1.0)
	
	return globalMultiplicator
