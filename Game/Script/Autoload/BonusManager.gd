extends Node
#Force/Vitesse | Spin/Angle/Complexity
#Bonus des Recherches
var BonusTypesRecherches = ["PrixHydrogeneAugmentation", "HydrogeneCoeffMultiplicateurRapport", "HeliumCoeffMultiplicateurRapport", "HydrogeneAttributsCostDivided", "HydrogeneForceCostDivided", "HydrogeneVitesseCostDivided", "HeliumAttributsCostDivided", "HeliumSpinCostDivided", "HeliumAngleCostDivided", "HeliumComplexityCostDivided"]
var CurrentBonusesRecherches = {"PrixHydrogeneAugmentation" : Big.new(0.0), "HydrogeneCoeffMultiplicateurRapport" : Big.new(1.0), "HeliumCoeffMultiplicateurRapport" : Big.new(1.0)}

#Amélioration de l'helium
var BonusTypesAmeliorationHelium = ["HydrogeneOutputMultiply", "HydrogeneAttributsCoefficientAdd"]
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
	
	for bonusTypesRecherches in BonusTypesRecherches:
		CurrentBonusesRecherches[bonusTypesRecherches] = Big.new(0.0)
	
	for recherche in RessourceManager.ListeRecherches:
		if recherche.IsUnlocked:
			CurrentBonusesRecherches[recherche.Augmentation] = Big.add(CurrentBonusesRecherches[recherche.Augmentation], recherche.AugmentationPercent)


#Mise à jour des bonus des améliorations de l'Helium
func MajBonusAmeliorationHelium():
	InfosPartie.MajInformationsPartie() #Pour l'instant pas utile ici, mais plus tard oui
	
	#Définition des bonus de base, si c'est une multiplication on set a 1, une addition a 0
	for bonusTypeAmeliorationHelium in BonusTypesAmeliorationHelium:
		if bonusTypeAmeliorationHelium.contains("Multiply"):
			CurrentBonusesAmeliorationHelium[bonusTypeAmeliorationHelium] = Big.new(1.0)
		if bonusTypeAmeliorationHelium.contains("Add"):
			CurrentBonusesAmeliorationHelium[bonusTypeAmeliorationHelium] = Big.new(0.0)
	
	#On calcul les CurrentBonus selon si c'est un multiplication ou une addition
	for ameliorationHelium in RessourceManager.ListeAmeliorationsHelium:
		if ameliorationHelium.IsUnlocked:
			var BonusCalculNiveau = Big.multiply(ameliorationHelium.BonusAmeliorationHelium, ameliorationHelium.Level)
			if ameliorationHelium.BonusTypeAmeliorationHelium.contains("Multiply"):
				CurrentBonusesAmeliorationHelium[ameliorationHelium.BonusTypeAmeliorationHelium] = Big.multiply(CurrentBonusesAmeliorationHelium[ameliorationHelium.BonusTypeAmeliorationHelium], BonusCalculNiveau)
			elif ameliorationHelium.BonusTypeAmeliorationHelium.contains("Add"):
				CurrentBonusesAmeliorationHelium[ameliorationHelium.BonusTypeAmeliorationHelium] = Big.add(CurrentBonusesAmeliorationHelium[ameliorationHelium.BonusTypeAmeliorationHelium], BonusCalculNiveau)


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
	
	for CurrentResearchBonus in CurrentBonusesRecherches:
		if CurrentResearchBonus.contains(Name) and CurrentResearchBonus.contains("CoeffMultiplicateurRapport"):
			recherchesMultiplicator = Big.add(recherchesMultiplicator, CurrentBonusesRecherches[CurrentResearchBonus])
	
	for CurrentBonus in CurrentBonusesAmeliorationHelium:
		if CurrentBonus.contains(Name) and CurrentBonus.contains("OutputMultiply"):
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


#Permet de récupérer le diviseur du prix des attributs des atomes
func GetRecherchesAttributsCostsDivided(attribut): 
	var diviseur = Big.new(0.0)
	
	for currentBonusesRecherches in CurrentBonusesRecherches:
		if (currentBonusesRecherches.contains("CostDivided") and currentBonusesRecherches.contains(attribut.Name) and currentBonusesRecherches.contains(attribut.Atome.Name)) or (currentBonusesRecherches.contains("CostDivided") and currentBonusesRecherches.contains("Attributs") and currentBonusesRecherches.contains(attribut.Atome.Name)):
			diviseur = Big.add(diviseur, CurrentBonusesRecherches[currentBonusesRecherches])
	
	if diviseur.isEqualTo(Big.new(0.0)):
		diviseur = Big.new(1.0)
		
	return diviseur
