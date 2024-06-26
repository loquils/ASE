extends Node

#Bonus des Recherches
var BonusTypesRecherches = ["PrixHydrogeneAugmentation", "HydrogeneCoeffMultiplicateurRapport", "HeliumCoeffMultiplicateurRapport"]
var CurrentBonusesResearches = {"PrixHydrogeneAugmentation" : Big.new(0.0), "HydrogeneCoeffMultiplicateurRapport" : Big.new(1.0), "HeliumCoeffMultiplicateurRapport" : Big.new(1.0)}

#Amélioration de l'helium
var BonusTypesAmeliorationHelium = ["HydrogeneRendementMultiply", "HydrogeneAttributsCoefficientAdd"]
var CurrentBonusesAmeliorationHelium = {}

#Bonus recherches matière noire
var BonusTypesRecherchesMatiereNoire = ["HydrogeneCoeffMultiplicateurRapport", "HydrogeneRechercheMNAcheteeCoeffMultiplicateurRapport", "HeliumCoeffMultiplicateurRapport"]
var CurrentBonusesRecherchesMatiereNoire = {}

func _ready():
	if len(BonusTypesAmeliorationHelium) == 0:
		for bonusType in BonusTypesAmeliorationHelium:
			CurrentBonusesAmeliorationHelium[bonusType] = Big.new(0.0)
	
	if len(BonusTypesRecherchesMatiereNoire) == 0:
		for bonusTypeRecherchesMatiereNoire in BonusTypesRecherchesMatiereNoire:
			CurrentBonusesRecherchesMatiereNoire[bonusTypeRecherchesMatiereNoire] = Big.new(0.0)


#Permet de mettre à jour le dictionnaire des ressources
#On parcour la liste des ressources, et on ajoute les bonus
func MajBonusRecherches():
	InfosPartie.MajInformationsPartie() #Pour l'instant pas utile ici, mais plus tard oui
	
	CurrentBonusesResearches["PrixHydrogeneAugmentation"] = Big.new(0.0)
	CurrentBonusesResearches["HydrogeneCoeffMultiplicateurRapport"] = Big.new(0.0)
	CurrentBonusesResearches["HeliumCoeffMultiplicateurRapport"] = Big.new(0.0)
	for recherche in RessourceManager.ListeRecherches:
		if recherche.IsUnlocked:
			CurrentBonusesResearches[recherche.Augmentation] = Big.add(CurrentBonusesResearches[recherche.Augmentation], recherche.AugmentationPercent)


#Mise à jour des bonus des améliorations de l'Helium
func MajBonusAmeliorationHelium():
	InfosPartie.MajInformationsPartie() #Pour l'instant pas utile ici, mais plus tard oui
	
	RessourceManager.ListeAtomes["Hydrogene"].GlobalMultiplicator = Big.new(1.0)
	
	for CurrentBonus in CurrentBonusesAmeliorationHelium:
		CurrentBonusesAmeliorationHelium[CurrentBonus] = Big.new(0.0)
	
	for ameliorationHelium in RessourceManager.ListeAmeliorationsHelium:
		if ameliorationHelium.IsUnlocked:
			CurrentBonusesAmeliorationHelium[ameliorationHelium.BonusTypeAmeliorationHelium] = Big.add(CurrentBonusesAmeliorationHelium[ameliorationHelium.BonusTypeAmeliorationHelium], Big.multiply(ameliorationHelium.BonusAmeliorationHelium, ameliorationHelium.Level))
	
	for CurrentBonus in CurrentBonusesAmeliorationHelium:
		match CurrentBonus:
			"HydrogeneRendementMultiply":
				if CurrentBonusesAmeliorationHelium[CurrentBonus].isEqualTo(Big.new(0.0)):
					RessourceManager.ListeAtomes["Hydrogene"].ApportAtome = RessourceManager.ListeAtomes["Hydrogene"].ApportAtomeBase
				else:
					RessourceManager.ListeAtomes["Hydrogene"].GlobalMultiplicator = Big.multiply(RessourceManager.ListeAtomes["Hydrogene"].GlobalMultiplicator, CurrentBonusesAmeliorationHelium[CurrentBonus])

			"HydrogeneAttributsCoefficientAdd":
				for attributHydrogene in RessourceManager.ListeAtomes["Hydrogene"].ListeAttribs:
					attributHydrogene.CoefficientRapport = Big.add(attributHydrogene.CoefficientBaseRapport, BonusManager.CurrentBonusesAmeliorationHelium[CurrentBonus])


#Mise à jour des bonus des recherches de matière noire
func MajBonusRecherchesMatiereNoire():
	InfosPartie.MajInformationsPartie()
	
	for bonusTypeRecherchesMatiereNoire in BonusTypesRecherchesMatiereNoire:
		CurrentBonusesRecherchesMatiereNoire[bonusTypeRecherchesMatiereNoire] = Big.new(0.0)
		
	for rechercheMatiereNoire in RessourceManager.ListeRecherchesMatiereNoire:
		if rechercheMatiereNoire.IsUnlocked:
			#On check si on a une recherche en fonction de la quantité de recherche achetée, faudra changer ça je pense
			if rechercheMatiereNoire.Augmentation == "HydrogeneRechercheMNAcheteeCoeffMultiplicateurRapport":
				CurrentBonusesRecherchesMatiereNoire[rechercheMatiereNoire.Augmentation] = Big.add(CurrentBonusesRecherchesMatiereNoire[rechercheMatiereNoire.Augmentation], Big.multiply(rechercheMatiereNoire.AugmentationPercent, InfosPartie.RecherchesMatiereNoireAchetees))
			else:
				CurrentBonusesRecherchesMatiereNoire[rechercheMatiereNoire.Augmentation] = Big.add(CurrentBonusesRecherchesMatiereNoire[rechercheMatiereNoire.Augmentation], rechercheMatiereNoire.AugmentationPercent)


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
	
	var matiereNoireMultiplicateur = GetDarkMaterMultiplicator(Name)
	
	return Big.multiply(globalMultiplicator, matiereNoireMultiplicateur)


#Permet de récupérer le multiplicateur sur les recherches de matière norie du rendu des atomes
func GetDarkMaterMultiplicator(Name):
	var matiereNoireMultiplicateur = Big.new(1.0)
	
	for CurrentRechercheMatiereNoireBonus in CurrentBonusesRecherchesMatiereNoire:
		if CurrentRechercheMatiereNoireBonus.contains(Name) and CurrentRechercheMatiereNoireBonus.contains("CoeffMultiplicateurRapport"):
			var multiplicator = Big.new(1.0)
			if not CurrentBonusesRecherchesMatiereNoire[CurrentRechercheMatiereNoireBonus].isEqualTo(Big.new(0.0)):
				multiplicator = CurrentBonusesRecherchesMatiereNoire[CurrentRechercheMatiereNoireBonus]			
			matiereNoireMultiplicateur = Big.multiply(matiereNoireMultiplicateur, multiplicator)
	
	if matiereNoireMultiplicateur.isEqualTo(Big.new(0.0)):
		matiereNoireMultiplicateur = Big.new(1.0)
	
	return matiereNoireMultiplicateur
