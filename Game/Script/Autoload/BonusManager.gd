extends Node

#Bonus des Recherches
var BonusTypesRecherches = ["PrixHydrogeneAugmentation", "AllOutputMultiply", "HydrogeneOutputMultiply", "HeliumOutputMultiply", "HydrogeneAttributsCostDivided", "HydrogeneForceCostDivided", "HydrogeneVitesseCostDivided", "HeliumAttributsCostDivided", "HeliumSpinCostDivided", "HeliumAngleCostDivided", "HeliumComplexiteeCostDivided", "HydrogeneForceCoefficientMultiply", "HydrogeneVitesseCoefficientMultiply"]
var CurrentBonusesRecherches = {}

#Amélioration de l'helium
var BonusTypesAmeliorationHelium = ["HydrogeneOutputMultiply", "HydrogeneAttributsCoefficientAdd", "PressionEfficacitee0", "PressionEfficacitee1","TemperatureEfficacitee0", "TemperatureEfficacitee1"]
var CurrentBonusesAmeliorationHelium = {}

#Amélioration du lithium
var BonusTypesAmeliorationLithium = ["HeliumOutputMultiply", "HeliumAttributsCostDivided" , "ProtonEfficacitee", "NeutronEfficacitee", "ElectronsKEfficacitee"]
var CurrentBonusesAmeliorationLithium = {}

#Amélioration du Beryllium
var AtomesAmeliorationBeryllium = ["Hydrogene", "Helium", "Lithium", "Beryllium"]
var BonusTypesAmeliorationBeryllium = ["HydrogeneLevel", "HeliumLevel" , "LithiumLevel", "BerylliumLevel", "HydrogeneNumberAdd", "HeliumNumberAdd" , "LithiumNumberAdd", "BerylliumNumberAdd"]
var BaseBonusesAmeliorationsBerylliumPercent = {"HydrogeneOutputMultiply" : Big.new(0.05), "HeliumOutputMultiply" : Big.new(0.04), "LithiumOutputMultiply" : Big.new(0.03), "BerylliumOutputMultiply" : Big.new(0.02)}
var CurrentBonusesAmeliorationBeryllium = {}

#Amélioration du Bore
var BonusBaseAmeliorationsBore = {"BerylliumOutputMultiply" : Big.new(0.05), "DarkMatterOutputMultiply" : Big.new(0.0001)}
var BonusAmeliorationsBore = {"BerylliumOutputMultiply" : Big.new(0.05), "DarkMatterOutputMultiply" : Big.new(0.0001)}
var BonusTypesAmeliorationBore = ["QuantiteeMatiere", "BonusQuantiteeMatiere", "AmeliorationBoreBonusBeryllium", "AmeliorationBoreBonusDarkMatter"]
var CurrentBonusesAmeliorationBore = {}

#Bonus recherches matière noire
var CurrentBonusesRecherchesMatiereNoire = {}

func _ready():
	BonusTypesRecherches = InitializeRecherchesBonusTypes()
	
	if len(CurrentBonusesRecherches) == 0:
		for bonusType in BonusTypesRecherches:
			CurrentBonusesRecherches[bonusType] = Big.new(0.0)
	
	if len(CurrentBonusesAmeliorationHelium) == 0:
		for bonusType in BonusTypesAmeliorationHelium:
			CurrentBonusesAmeliorationHelium[bonusType] = Big.new(0.0)
	
	if len(CurrentBonusesAmeliorationLithium) == 0:
		for bonusType in BonusTypesAmeliorationLithium:
			CurrentBonusesAmeliorationLithium[bonusType] = Big.new(0.0)
	
	if len(CurrentBonusesAmeliorationBeryllium) == 0:
		for bonusType in BonusTypesAmeliorationBeryllium:
			CurrentBonusesAmeliorationBeryllium[bonusType] = Big.new(0.0)
	
	if len(CurrentBonusesAmeliorationBore) == 0:
		for bonusType in BonusTypesAmeliorationBore:
			CurrentBonusesAmeliorationBore[bonusType] = Big.new(0.0)
	
	if len(CurrentBonusesRecherchesMatiereNoire) == 0:
		for bonusTypeRecherchesMatiereNoire in BonusTypesRecherches:
			CurrentBonusesRecherchesMatiereNoire[bonusTypeRecherchesMatiereNoire] = Big.new(0.0)

#Permet de mettre à jour le dictionnaire des ressources
#On parcour la liste des ressources, et on ajoute les bonus
func MajBonusRecherches():
	InfosPartie.MajInformationsPartie() #Pour l'instant pas utile ici, mais plus tard oui
	
	for bonusTypesRecherches in BonusTypesRecherches:
		CurrentBonusesRecherches[bonusTypesRecherches] = Big.new(0.0)
	
	for recherche in RessourceManager.ListeRecherches:
		if recherche.IsUnlocked:
			for ameliorationRecherche in recherche.Augmentation:
				if ameliorationRecherche.contains("ParRecherche"):
					CurrentBonusesRecherches[ameliorationRecherche.replace("ParRecherche", "")] = Big.add(CurrentBonusesRecherches[ameliorationRecherche.replace("ParRecherche", "")], Big.multiply(recherche.AugmentationPercent, InfosPartie.RecherchesAchetees))
				else:
					CurrentBonusesRecherches[ameliorationRecherche] = Big.add(CurrentBonusesRecherches[ameliorationRecherche], recherche.AugmentationPercent)


#Mise à jour des bonus des améliorations de l'Helium
func MajBonusAmeliorationHelium():
	InfosPartie.MajInformationsPartie() #Pour l'instant pas utile ici, mais plus tard oui
	
	for bonusTypeAmeliorationHelium in BonusTypesAmeliorationHelium:
		CurrentBonusesAmeliorationHelium[bonusTypeAmeliorationHelium] = Big.new(0.0)
		
	#On calcul les CurrentBonus selon le bonus de l'amelioration et pas son niveau
	for ameliorationHelium in RessourceManager.ListeAmeliorationsHelium:
		if ameliorationHelium.IsUnlocked:
			CurrentBonusesAmeliorationHelium[ameliorationHelium.BonusTypeAmeliorationHelium] = ameliorationHelium.BonusAmeliorationHelium


#Mise à jour des bonus des améliorations du lithium
func MajBonusAmeliorationLithium():
	InfosPartie.MajInformationsPartie() #Pour l'instant pas utile ici, mais plus tard oui
	
	for bonusTypeAmeliorationLithium in BonusTypesAmeliorationLithium:
		CurrentBonusesAmeliorationLithium[bonusTypeAmeliorationLithium] = Big.new(0.0)
	
	for ameliorationLithium in RessourceManager.ListeAmeliorationsLithium:
		if ameliorationLithium.IsUnlocked:
			CurrentBonusesAmeliorationLithium[ameliorationLithium.BonusTypeAmeliorationLithium] = ameliorationLithium.BonusAmeliorationLithium


#Mise à jour des bonus des améliorations du Beryllium
func MajBonusAmeliorationBeryllium():
	InfosPartie.MajInformationsPartie() #Pour l'instant pas utile ici, mais plus tard oui
	
	for bonusTypeAmeliorationBeryllium in BonusTypesAmeliorationBeryllium:
		CurrentBonusesAmeliorationBeryllium[bonusTypeAmeliorationBeryllium] = Big.new(0.0)
	
	for ameliorationBeryllium in RessourceManager.ListeAmeliorationsBeryllium:
		if ameliorationBeryllium.IsUnlocked and ameliorationBeryllium.CategorieAmeliorationBeryllium == AmeliorationBeryllium.CategorieAmeliorationBerylliumEnum.BonusAdd:
			var bonusesWithLevel = ameliorationBeryllium.GetBonusesArray()
			for i in range(0,4):
				CurrentBonusesAmeliorationBeryllium[ameliorationBeryllium.BonusTypeAmeliorationBeryllium[i] + "NumberAdd"] = Big.add(CurrentBonusesAmeliorationBeryllium[ameliorationBeryllium.BonusTypeAmeliorationBeryllium[i] + "NumberAdd"], bonusesWithLevel[i])

	for ameliorationBeryllium in RessourceManager.ListeAmeliorationsBeryllium:
		if ameliorationBeryllium.IsUnlocked and ameliorationBeryllium.CategorieAmeliorationBeryllium == AmeliorationBeryllium.CategorieAmeliorationBerylliumEnum.Normal:
			var bonusesWithLevel = ameliorationBeryllium.GetBonusesArray()
			for i in range(0,4):
				CurrentBonusesAmeliorationBeryllium[ameliorationBeryllium.BonusTypeAmeliorationBeryllium[i] + "Level"] = Big.add(CurrentBonusesAmeliorationBeryllium[ameliorationBeryllium.BonusTypeAmeliorationBeryllium[i] + "Level"], bonusesWithLevel[i])


#Mise à jour des bonus des améliorations du bore
func MajBonusAmeliorationBore():
	InfosPartie.MajInformationsPartie() #Pour l'instant pas utile ici, mais plus tard oui
	
	for bonusTypeAmeliorationBore in BonusTypesAmeliorationBore:
		CurrentBonusesAmeliorationBore[bonusTypeAmeliorationBore] = Big.new(0.0)
	
	for ameliorationBore in RessourceManager.ListeAmeliorationsBore:
		print(ameliorationBore.BonusTypeAmeliorationBore + " : " + str(ameliorationBore.BonusAmeliorationBore) + " | " + str(ameliorationBore.Level) + " Unlocked ? " + str(ameliorationBore.IsUnlocked))
		if ameliorationBore.IsUnlocked:
			CurrentBonusesAmeliorationBore[ameliorationBore.BonusTypeAmeliorationBore] = Big.multiply(ameliorationBore.BonusAmeliorationBore, ameliorationBore.Level)


#Mise à jour des bonus des recherches de matière noire
func MajBonusRecherchesMatiereNoire():
	InfosPartie.MajInformationsPartie()
	
	for bonusTypeRecherchesMatiereNoire in BonusTypesRecherches:
		CurrentBonusesRecherchesMatiereNoire[bonusTypeRecherchesMatiereNoire] = Big.new(0.0)
		
	for rechercheMatiereNoire in RessourceManager.ListeRecherchesMatiereNoire:
		if rechercheMatiereNoire.IsUnlocked:
			for ameliorationRechercheMatiereNoire in rechercheMatiereNoire.Augmentation:
				if ameliorationRechercheMatiereNoire.contains("ParRechercheMN"):
					CurrentBonusesRecherchesMatiereNoire[ameliorationRechercheMatiereNoire.replace("ParRechercheMN", "")] = Big.add(CurrentBonusesRecherchesMatiereNoire[ameliorationRechercheMatiereNoire.replace("ParRechercheMN", "")], Big.multiply(rechercheMatiereNoire.AugmentationPercent, InfosPartie.RecherchesMatiereNoireAchetees))
				else:
					CurrentBonusesRecherchesMatiereNoire[ameliorationRechercheMatiereNoire] = Big.add(CurrentBonusesRecherchesMatiereNoire[ameliorationRechercheMatiereNoire], rechercheMatiereNoire.AugmentationPercent)


#Récupère le prix de l'Hydrogène avec les bonus
func GetPrixHydrogene():
	var recherchesPrice = Big.new(0.0)
	var recherchesMatiereNoirePrice = Big.new(0.0)
	
	recherchesPrice = BonusManager.CurrentBonusesRecherches["PrixHydrogeneAugmentation"]
	recherchesMatiereNoirePrice = BonusManager.CurrentBonusesRecherchesMatiereNoire["PrixHydrogeneAugmentation"]
	
	var globalPrice = Big.add(recherchesPrice, recherchesMatiereNoirePrice)
	
	return globalPrice


#Permet de récupérer le multiplicateur global du rendu des atomes (prend en compte les recherches et les amélioration Helium/Lithium
func GetGlobalMultiplicator(Name):
	var recherchesMultiplicator = Big.new(0.0)
	var heliumMultiplicator = Big.new(0.0)
	var lithiumMultiplicateur = Big.new(0.0)
	var BerylliumMultiplicateur = Big.new(0.0)
	var BoreMultiplicateur = Big.new(0.0)
	
	for CurrentResearchBonus in CurrentBonusesRecherches:
		if (CurrentResearchBonus.contains(Name) and CurrentResearchBonus.contains("OutputMultiply")) or CurrentResearchBonus.contains("AllOutputMultiply"):
			recherchesMultiplicator = Big.add(recherchesMultiplicator, CurrentBonusesRecherches[CurrentResearchBonus])
	
	for CurrentBonus in CurrentBonusesAmeliorationHelium:
		if CurrentBonus.contains(Name) and CurrentBonus.contains("OutputMultiply"):
			heliumMultiplicator = Big.add(heliumMultiplicator, GetAmeliorationHeliumCoefficientSortieAvecNiveau())
	
	for currentBonusAmeliorationLithiumBonus in CurrentBonusesAmeliorationLithium:
		if currentBonusAmeliorationLithiumBonus.contains(Name) and currentBonusAmeliorationLithiumBonus.contains("OutputMultiply"):
			lithiumMultiplicateur = Big.add(lithiumMultiplicateur, GetAmeliorationLithiumCoefficientProtonAvecNiveau())
	
	BerylliumMultiplicateur = GetAmeliorationBerylliumTotalBonuses(Name)
	
	BoreMultiplicateur = GetAmeliorationBoreOutputBonus(Name)
	
	var globalMultiplicator = Big.add(BoreMultiplicateur, Big.add(BerylliumMultiplicateur, Big.add(lithiumMultiplicateur, Big.add(recherchesMultiplicator, heliumMultiplicator))))
	
	return globalMultiplicator


#Permet de récupérer le multiplicateur sur les recherches de matière noire du rendu des atomes
func GetDarkMaterMultiplicator(Name):
	var matiereNoireMultiplicateur = Big.new(0.0)
	
	for currentRechercheMatiereNoireBonus in CurrentBonusesRecherchesMatiereNoire:
		if currentRechercheMatiereNoireBonus.contains(Name) and currentRechercheMatiereNoireBonus.contains("OutputMultiply"):
			matiereNoireMultiplicateur = Big.add(matiereNoireMultiplicateur, CurrentBonusesRecherchesMatiereNoire[currentRechercheMatiereNoireBonus])
	
	return matiereNoireMultiplicateur


#Permet de récupérer le diviseur sur les recherches de matière noire du rendu des atomes
func GetDarkMaterDiviseur(Name):
	var matiereNoireDiviseur = Big.new(0.0)
	
	for currentRechercheMatiereNoireBonus in CurrentBonusesRecherchesMatiereNoire:
		if currentRechercheMatiereNoireBonus.contains(Name) and currentRechercheMatiereNoireBonus.contains("AttributsCostDivided"):
			matiereNoireDiviseur = Big.add(matiereNoireDiviseur, CurrentBonusesRecherchesMatiereNoire[currentRechercheMatiereNoireBonus])
	
	if matiereNoireDiviseur.isEqualTo(Big.new(0.0)):
		matiereNoireDiviseur = Big.new(1.0)
		
	return matiereNoireDiviseur


#Permet de récupérer le bonus sur le delta de matière noire.
func GetDeltaDarkMatterBonus():
	var rechercheBonus = CurrentBonusesRecherches["MatiereNoireOutputMultiply"]
	var ameliorationsBoreBonus = GetAmeliorationBoreDMOutputBonus()
	return Big.add(rechercheBonus, ameliorationsBoreBonus)


#Permet de récupérer le bonus sur le delta de matière noire des recherches matière noire.
func GetDeltaDarkMatterBonusDarkMatterResearch():
	return CurrentBonusesRecherchesMatiereNoire["MatiereNoireOutputMultiply"]


#Permet de récupérer le diviseur du prix des attributs des atomes
func GetRecherchesAttributsCostsDivided(attribut):
	var diviseurRecherches = Big.new(0.0)
	var diviseurLithium = Big.new(0.0)
	
	for currentBonusesRecherches in CurrentBonusesRecherches:
		if (currentBonusesRecherches.contains("CostDivided") and currentBonusesRecherches.contains(attribut.Name) and currentBonusesRecherches.contains(attribut.Atome.Name)) or (currentBonusesRecherches.contains("CostDivided") and currentBonusesRecherches.contains("Attributs") and currentBonusesRecherches.contains(attribut.Atome.Name)):
			diviseurRecherches = Big.add(diviseurRecherches, CurrentBonusesRecherches[currentBonusesRecherches])
	
	for currentBonusAmeliorationLithiumBonus in CurrentBonusesAmeliorationLithium:
		if currentBonusAmeliorationLithiumBonus.contains(attribut.Atome.Name) and currentBonusAmeliorationLithiumBonus.contains("CostDivided"):
			diviseurLithium =  Big.add(diviseurLithium, GetAmeliorationLithiumCoefficientNeutronAvecNiveau())
	
	var diviseurGlobal = Big.add(diviseurRecherches, diviseurLithium)

	if diviseurGlobal.isEqualTo(Big.new(0.0)):
		diviseurGlobal = Big.new(1.0)
	
	return diviseurGlobal


#Permet de récupérer le diviseur du prix des améliorations Hélium.
func GetRecherchesAmeliorationHeCostsDivided(id):
	var diviseurRecherches = Big.new(0.0)
	
	var diviseurRecherchesMatiereNoire = Big.new(0.0)
	
	for currentBonusesRecherches in CurrentBonusesRecherches:
		if (currentBonusesRecherches.contains("AmeliorationHelium") and currentBonusesRecherches.contains("CostDivided")):
			if (currentBonusesRecherches.replace("AmeliorationHelium", "").replace("CostDivided", "").contains(str(id))):
				diviseurRecherches = Big.add(diviseurRecherches, CurrentBonusesRecherches[currentBonusesRecherches])
		if (currentBonusesRecherches.contains("AmeliorationsHeCostDivided")):
			diviseurRecherches = Big.add(diviseurRecherches, CurrentBonusesRecherches[currentBonusesRecherches])
	
	for currentBonusesRecherchesMatiereNoire in CurrentBonusesRecherchesMatiereNoire:
		if (currentBonusesRecherchesMatiereNoire.contains("AmeliorationHelium") and currentBonusesRecherchesMatiereNoire.contains("CostDivided")):
			if (currentBonusesRecherchesMatiereNoire.replace("AmeliorationHelium", "").replace("CostDivided", "").contains(str(id))):
				diviseurRecherchesMatiereNoire = Big.add(diviseurRecherchesMatiereNoire, CurrentBonusesRecherchesMatiereNoire[currentBonusesRecherchesMatiereNoire])
		elif currentBonusesRecherchesMatiereNoire.contains("AmeliorationsHeCostDivided"):
			diviseurRecherchesMatiereNoire = Big.add(diviseurRecherchesMatiereNoire, CurrentBonusesRecherchesMatiereNoire[currentBonusesRecherchesMatiereNoire])
	
	if diviseurRecherchesMatiereNoire.isEqualTo(Big.new(0.0)):
		diviseurRecherchesMatiereNoire = Big.new(1.0)
	
	if diviseurRecherches.isEqualTo(Big.new(0.0)):
		diviseurRecherches = Big.new(1.0)
	
	var diviseurGlobal = Big.multiply(diviseurRecherches, diviseurRecherchesMatiereNoire)
	
	if diviseurGlobal.isEqualTo(Big.new(0.0)):
		diviseurGlobal = Big.new(1.0)
	
	return diviseurGlobal


#Permet de récupérer le diviseur du prix des améliorations Hélium.
func GetRecherchesAmeliorationLithiumCostsDivided(id):
	var diviseurRecherches = Big.new(0.0)
	
	var diviseurRecherchesMatiereNoire = Big.new(0.0)
	
	for currentBonusesRecherches in CurrentBonusesRecherches:
		if (currentBonusesRecherches.contains("AmeliorationLithium") and currentBonusesRecherches.contains("CostDivided")):
			if (currentBonusesRecherches.replace("AmeliorationLithium", "").replace("CostDivided", "").contains(str(id))):
				diviseurRecherches = Big.add(diviseurRecherches, CurrentBonusesRecherches[currentBonusesRecherches])
		if (currentBonusesRecherches.contains("AmeliorationsLithiumCostDivided")):
			diviseurRecherches = Big.add(diviseurRecherches, CurrentBonusesRecherches[currentBonusesRecherches])
	
	for currentBonusesRecherchesMatiereNoire in CurrentBonusesRecherchesMatiereNoire:
		if (currentBonusesRecherchesMatiereNoire.contains("AmeliorationLithium") and currentBonusesRecherchesMatiereNoire.contains("CostDivided")):
			if (currentBonusesRecherchesMatiereNoire.replace("AmeliorationLithium", "").replace("CostDivided", "").contains(str(id))):
				diviseurRecherchesMatiereNoire = Big.add(diviseurRecherchesMatiereNoire, CurrentBonusesRecherchesMatiereNoire[currentBonusesRecherchesMatiereNoire])
		elif currentBonusesRecherchesMatiereNoire.contains("AmeliorationsLithiumCostDivided"):
			diviseurRecherchesMatiereNoire = Big.add(diviseurRecherchesMatiereNoire, CurrentBonusesRecherchesMatiereNoire[currentBonusesRecherchesMatiereNoire])
	
	if diviseurRecherchesMatiereNoire.isEqualTo(Big.new(0.0)):
		diviseurRecherchesMatiereNoire = Big.new(1.0)
	
	if diviseurRecherches.isEqualTo(Big.new(0.0)):
		diviseurRecherches = Big.new(1.0)
	
	var diviseurGlobal = Big.multiply(diviseurRecherches, diviseurRecherchesMatiereNoire)
	
	if diviseurGlobal.isEqualTo(Big.new(0.0)):
		diviseurGlobal = Big.new(1.0)
	
	return diviseurGlobal


#Permet de récupérer le coefficient multiplacateur sur les attributs des atomes
func GetRecherchesAttributsCoefficientMultiplicateur(attribut):
	var coefficientMultiplicateur = Big.new(0.0)
	
	for currentBonusesRecherches in CurrentBonusesRecherches:
		if (currentBonusesRecherches.contains("CoefficientMultiply") and currentBonusesRecherches.contains(attribut.Name) and currentBonusesRecherches.contains(attribut.Atome.Name)) or (currentBonusesRecherches.contains("CoefficientMultiply") and currentBonusesRecherches.contains("Attributs") and currentBonusesRecherches.contains(attribut.Atome.Name)):
			coefficientMultiplicateur = Big.add(coefficientMultiplicateur, CurrentBonusesRecherches[currentBonusesRecherches])
	
	return coefficientMultiplicateur

#-----------------------------------------Helium-----------------------------------------------------------------

#Permet de récupérer le coefficient sur la pression 2 des améliorations hélium
func GetAmeliorationHeliumCoefficientPression1():
	return CurrentBonusesAmeliorationHelium["PressionEfficacitee1"]


#Permet de récupérer le coefficient sur la pression 1 des améliorations hélium
func GetAmeliorationHeliumCoefficientPression0():
	return Big.add(CurrentBonusesAmeliorationHelium["PressionEfficacitee0"], GetAmeliorationHeliumCoefficientPression1AvecNiveau())


#Permet de récupérer le coefficient des améliorations d'helium 
func GetAmeliorationHeliumPressionMultiplicateur():
	return Big.add(CurrentBonusesAmeliorationHelium["HydrogeneOutputMultiply"], GetAmeliorationHeliumCoefficientPression0AvecNiveau())


#Permet de récupérer le coefficient d'ajout sur la pression 1 des améliorations hélium en fontion du niveau de l'amélioration
func GetAmeliorationHeliumCoefficientPression1AvecNiveau():
	var nomTypeBonusAmelioration = "PressionEfficacitee1"
	var objetsTrouvesDansListe = RessourceManager.ListeAmeliorationsHelium.filter(func(amelioration): return amelioration.BonusTypeAmeliorationHelium == nomTypeBonusAmelioration)
	if (len(objetsTrouvesDansListe) != 1):
		return
	return Big.multiply(CurrentBonusesAmeliorationHelium[nomTypeBonusAmelioration], objetsTrouvesDansListe[0].Level)


#Permet de récupérer le coefficient sur la pression 0 des améliorations hélium en fontion du niveau de l'amélioration
func GetAmeliorationHeliumCoefficientPression0AvecNiveau():
	var nomTypeBonusAmelioration = "PressionEfficacitee0"
	var objetsTrouvesDansListe = RessourceManager.ListeAmeliorationsHelium.filter(func(amelioration): return amelioration.BonusTypeAmeliorationHelium == nomTypeBonusAmelioration)
	if (len(objetsTrouvesDansListe) != 1):
		return
	var bonusPression1 = GetAmeliorationHeliumCoefficientPression1AvecNiveau()
	var bonusPression0 = Big.add(CurrentBonusesAmeliorationHelium[nomTypeBonusAmelioration], bonusPression1)
	return Big.multiply(bonusPression0, objetsTrouvesDansListe[0].Level)


#Permet de récupérer le coefficient sur la pression 0 des améliorations hélium en fontion du niveau de l'amélioration
func GetAmeliorationHeliumCoefficientSortieAvecNiveau():
	var nomTypeBonusAmelioration = "HydrogeneOutputMultiply"
	var objetsTrouvesDansListe = RessourceManager.ListeAmeliorationsHelium.filter(func(amelioration): return amelioration.BonusTypeAmeliorationHelium == nomTypeBonusAmelioration)
	if (len(objetsTrouvesDansListe) != 1):
		return
	var bonusPression0 = GetAmeliorationHeliumCoefficientPression0AvecNiveau()
	var bonusPression = Big.add(CurrentBonusesAmeliorationHelium[nomTypeBonusAmelioration], bonusPression0)
	return Big.multiply(bonusPression, objetsTrouvesDansListe[0].Level)


#Permet de récupérer le coefficient sur la température 1 des améliorations hélium
func GetAmeliorationHeliumCoefficientTemperature1():
	return CurrentBonusesAmeliorationHelium["TemperatureEfficacitee1"]


#Permet de récupérer le coefficient sur la température 0 des améliorations hélium
func GetAmeliorationHeliumCoefficientTemperature0():
	return Big.add(CurrentBonusesAmeliorationHelium["TemperatureEfficacitee0"], GetAmeliorationHeliumCoefficientTemperature1AvecNiveau())


#Permet de récupérer le coefficient des améliorations d"helium sur les attributs de l'atome d'hydrogène
func GetAmeliorationHeliumTemperatureMultiplicateur():
	return Big.add(CurrentBonusesAmeliorationHelium["HydrogeneAttributsCoefficientAdd"], GetAmeliorationHeliumCoefficientTemperature0AvecNiveau())


#Permet de récupérer le coefficient d'ajout sur la Temperature 1 des améliorations hélium en fontion du niveau de l'amélioration
func GetAmeliorationHeliumCoefficientTemperature1AvecNiveau():
	var nomTypeBonusAmelioration = "TemperatureEfficacitee1"
	var objetsTrouvesDansListe = RessourceManager.ListeAmeliorationsHelium.filter(func(amelioration): return amelioration.BonusTypeAmeliorationHelium == nomTypeBonusAmelioration)
	if (len(objetsTrouvesDansListe) != 1):
		return
	return Big.multiply(CurrentBonusesAmeliorationHelium[nomTypeBonusAmelioration], objetsTrouvesDansListe[0].Level)


#Permet de récupérer le coefficient sur la Temperature 0 des améliorations hélium en fontion du niveau de l'amélioration
func GetAmeliorationHeliumCoefficientTemperature0AvecNiveau():
	var nomTypeBonusAmelioration = "TemperatureEfficacitee0"
	var objetsTrouvesDansListe = RessourceManager.ListeAmeliorationsHelium.filter(func(amelioration): return amelioration.BonusTypeAmeliorationHelium == nomTypeBonusAmelioration)
	if (len(objetsTrouvesDansListe) != 1):
		return
	var bonusTemperature1 = GetAmeliorationHeliumCoefficientTemperature1AvecNiveau()
	var bonusTemperature0 = Big.add(CurrentBonusesAmeliorationHelium[nomTypeBonusAmelioration], bonusTemperature1)
	return Big.multiply(bonusTemperature0, objetsTrouvesDansListe[0].Level)


#Permet de récupérer le coefficient sur la pression 0 des améliorations hélium en fontion du niveau de l'amélioration
func GetAmeliorationHeliumCoefficientTemperatureAvecNiveau():
	var nomTypeBonusAmelioration = "HydrogeneAttributsCoefficientAdd"
	var objetsTrouvesDansListe = RessourceManager.ListeAmeliorationsHelium.filter(func(amelioration): return amelioration.BonusTypeAmeliorationHelium == nomTypeBonusAmelioration)
	if (len(objetsTrouvesDansListe) != 1):
		return
	var bonusTemperature0 = GetAmeliorationHeliumCoefficientTemperature0AvecNiveau()
	var bonusTemperature = Big.add(CurrentBonusesAmeliorationHelium[nomTypeBonusAmelioration], bonusTemperature0)
	return Big.multiply(bonusTemperature, objetsTrouvesDansListe[0].Level)

#New Lithium -----------------------------------------------------------------------------------------------------------

#Permet de récupérer le coefficient d'un electron couche L
func GetAmeliorationLithiumCoefficientElectronsL():
	return CurrentBonusesAmeliorationLithium["ElectronsKEfficacitee"]


#Permet de récupérer le coefficient d'un electron couche K sur proton
func GetAmeliorationLithiumCoefficientProton():
	return Big.add(CurrentBonusesAmeliorationLithium["ProtonEfficacitee"], GetAmeliorationLithiumCoefficientElectronsLAvecNiveaux())


#Permet de récupérer le coefficient d'un electron couche K sur neutron
func GetAmeliorationLithiumCoefficientNeutron():
	return Big.add(CurrentBonusesAmeliorationLithium["NeutronEfficacitee"], GetAmeliorationLithiumCoefficientElectronsLAvecNiveaux())


#Permet de récupérer le coefficient sur les protons
func GetAmeliorationLithiumProtonMultiplicateur():
	return Big.add(CurrentBonusesAmeliorationLithium["HeliumOutputMultiply"], GetAmeliorationLithiumCoefficientElectronsKProtonAvecNiveau())


#Permet de récupérer le coefficient sur les neutrons
func GetAmeliorationLithiumNeutronMultiplicateur():
	return Big.add(CurrentBonusesAmeliorationLithium["HeliumAttributsCostDivided"], GetAmeliorationLithiumCoefficientElectronsKNeutronAvecNiveau())


#Permet de récupérer le coefficient d'ajout sur les electrons couche K en fontion du niveau de l'amélioration
func GetAmeliorationLithiumCoefficientElectronsLAvecNiveaux():
	var nomTypeBonusAmelioration = "ElectronsKEfficacitee"
	var objetsTrouvesDansListe = RessourceManager.ListeAmeliorationsLithium.filter(func(amelioration): return amelioration.BonusTypeAmeliorationLithium == nomTypeBonusAmelioration)
	if (len(objetsTrouvesDansListe) != 1):
		return
	return Big.multiply(CurrentBonusesAmeliorationLithium[nomTypeBonusAmelioration], objetsTrouvesDansListe[0].Level)


#Permet de récupérer le coefficient d'ajout sur les electrons couche K en fontion du niveau de l'amélioration
func GetAmeliorationLithiumCoefficientElectronsKProtonAvecNiveau():
	var nomTypeBonusAmelioration = "ProtonEfficacitee"
	var objetsTrouvesDansListe = RessourceManager.ListeAmeliorationsLithium.filter(func(amelioration): return amelioration.BonusTypeAmeliorationLithium == nomTypeBonusAmelioration)
	if (len(objetsTrouvesDansListe) != 1):
		return
	var bonusElectronsL = GetAmeliorationLithiumCoefficientElectronsLAvecNiveaux()
	var bonusProton = Big.add(CurrentBonusesAmeliorationLithium[nomTypeBonusAmelioration], bonusElectronsL)
	return Big.multiply(bonusProton, objetsTrouvesDansListe[0].Level)


#Permet de récupérer le coefficient d'ajout sur les electrons couche K en fontion du niveau de l'amélioration
func GetAmeliorationLithiumCoefficientElectronsKNeutronAvecNiveau():
	var nomTypeBonusAmelioration = "NeutronEfficacitee"
	var objetsTrouvesDansListe = RessourceManager.ListeAmeliorationsLithium.filter(func(amelioration): return amelioration.BonusTypeAmeliorationLithium == nomTypeBonusAmelioration)
	if (len(objetsTrouvesDansListe) != 1):
		return
	var bonusElectronsL = GetAmeliorationLithiumCoefficientElectronsLAvecNiveaux()
	var bonusProton = Big.add(CurrentBonusesAmeliorationLithium[nomTypeBonusAmelioration], bonusElectronsL)
	return Big.multiply(bonusProton, objetsTrouvesDansListe[0].Level)


#Permet de récupérer le coefficient sur les protons en fontion du niveau de l'amélioration
func GetAmeliorationLithiumCoefficientProtonAvecNiveau():
	var nomTypeBonusAmelioration = "HeliumOutputMultiply"
	var objetsTrouvesDansListe = RessourceManager.ListeAmeliorationsLithium.filter(func(amelioration): return amelioration.BonusTypeAmeliorationLithium == nomTypeBonusAmelioration)
	if (len(objetsTrouvesDansListe) != 1):
		return
	var bonusProtonElectronsK = GetAmeliorationLithiumCoefficientElectronsKProtonAvecNiveau()
	var bonusProton = Big.add(CurrentBonusesAmeliorationLithium[nomTypeBonusAmelioration], bonusProtonElectronsK)
	return Big.multiply(bonusProton, objetsTrouvesDansListe[0].Level)


#Permet de récupérer le coefficient sur les protons en fontion du niveau de l'amélioration
func GetAmeliorationLithiumCoefficientNeutronAvecNiveau():
	var nomTypeBonusAmelioration = "HeliumAttributsCostDivided"
	var objetsTrouvesDansListe = RessourceManager.ListeAmeliorationsLithium.filter(func(amelioration): return amelioration.BonusTypeAmeliorationLithium == nomTypeBonusAmelioration)
	if (len(objetsTrouvesDansListe) != 1):
		return
	var bonusNeutronElectronsK = GetAmeliorationLithiumCoefficientElectronsKNeutronAvecNiveau()
	var bonusProton = Big.add(CurrentBonusesAmeliorationLithium[nomTypeBonusAmelioration], bonusNeutronElectronsK)
	return Big.multiply(bonusProton, objetsTrouvesDansListe[0].Level)

#---------------------------Beryllium------------------------------

#Permet de récupérer les coeffs bonus des amélioration bérilyum sur les autres améliorations bérilyum
func GetAmeliorationBerylliumLevels():
	return [CurrentBonusesAmeliorationBeryllium["HydrogeneLevel"], CurrentBonusesAmeliorationBeryllium["HeliumLevel"], CurrentBonusesAmeliorationBeryllium["LithiumLevel"], CurrentBonusesAmeliorationBeryllium["BerylliumLevel"]]


#Permet de récupérer les coeffs bonus des amélioration bérilyum sur les autres améliorations bérilyum
func GetAmeliorationBerylliumNumberAddBonuses():
	return [CurrentBonusesAmeliorationBeryllium["HydrogeneNumberAdd"], CurrentBonusesAmeliorationBeryllium["HeliumNumberAdd"], CurrentBonusesAmeliorationBeryllium["LithiumNumberAdd"], CurrentBonusesAmeliorationBeryllium["BerylliumNumberAdd"]]


#Permet de récupérer les coeffs totaux des améliorations bérilyum (level x BaseBonus)
func GetAmeliorationBerylliumTotalBonuses(atomeName):
	if not AtomesAmeliorationBeryllium.has(atomeName):
		return Big.new(0.0)
	return Big.multiply(CurrentBonusesAmeliorationBeryllium[atomeName + "Level"], BaseBonusesAmeliorationsBerylliumPercent[atomeName + "OutputMultiply"])


#Permet de récupérer tous les coeffs totaux des améliorations bérilyum (level x BaseBonus)
func GetAmeliorationBerylliumAllTotalBonuses():
	return [GetAmeliorationBerylliumTotalBonuses("Hydrogene"), GetAmeliorationBerylliumTotalBonuses("Helium"), GetAmeliorationBerylliumTotalBonuses("Lithium"), GetAmeliorationBerylliumTotalBonuses("Beryllium")]

#----------------------------Bore-------------------------------

#Permet de récupérer la quantitée de matière unique, avec le bonus associé.
func GetAmeliorationBoreQuantiteeMatiereUnique(ameliorationBore):
	return Big.multiply(ameliorationBore.BonusAmeliorationBore, Big.add(Big.new(1.0), CurrentBonusesAmeliorationBore["BonusQuantiteeMatiere"]))


#Permet de récupérer le bonus unique sur la quantitée de matière.
func GetAmeliorationBoreQuantiteeUniqueBonus(ameliorationBore):
	return ameliorationBore.BonusAmeliorationBore


#Permet de récupérer la quantitée de matière avec le bonus de quantitée des améliorations Bore.
func GetAmeliorationBoreQuantiteeMatiereAvecBonus():
	return Big.multiply(CurrentBonusesAmeliorationBore["QuantiteeMatiere"], Big.add(Big.new(1.0), CurrentBonusesAmeliorationBore["BonusQuantiteeMatiere"]))


#Permet de récupérer le bonus total de l'amélioration de le sortie de béryllium en fonction de son niveau.
func GetAmeliorationBoreBerylliumBonusAvecNiveauxAmelioration(ameliorationBore):
	return Big.multiply(ameliorationBore.BonusAmeliorationBore, ameliorationBore.Level)


#Permet de récupérer le bonus de sortie sur le beryllium des améliorations Bore.
func GetAmeliorationBoreBerylliumCurrentBonus():
	return Big.multiply(BonusBaseAmeliorationsBore["BerylliumOutputMultiply"], Big.add(Big.new(1.0), CurrentBonusesAmeliorationBore["AmeliorationBoreBonusBeryllium"]))


#Permet de récupérer le bonus total sur la sortie du Beryllium des améliorations Bore.
func GetAmeliorationBoreOutputBonus(atomName):
	if not atomName == "Beryllium":
		return Big.new(0)
	
	return Big.multiply(GetAmeliorationBoreQuantiteeMatiereAvecBonus(), GetAmeliorationBoreBerylliumCurrentBonus())


#Permet de récupérer le bonus sur la matière noire des améliorations Bore.
func GetAmeliorationBoreDarkMatterCurrentBonus():
	return Big.multiply(BonusBaseAmeliorationsBore["DarkMatterOutputMultiply"], Big.add(Big.new(1.0), CurrentBonusesAmeliorationBore["AmeliorationBoreBonusDarkMatter"]))


#Permet de récupérer le bonus total sur la sortie de la matière noire des améliorations Bore.
func GetAmeliorationBoreDMOutputBonus():
	return Big.multiply(GetAmeliorationBoreQuantiteeMatiereAvecBonus(), GetAmeliorationBoreDarkMatterCurrentBonus())

#--------------------Initializing bonuses-------------------------------------------

#Permet de recupérer une liste de tous les bonus de recherches possibles.
func InitializeRecherchesBonusTypes():
	var bonusTypesRecherches = ["PrixHydrogeneAugmentation", "AllOutputMultiply"]
	for atome in RessourceManager.AtomsListInitializingGame:
		bonusTypesRecherches.append(atome.Name + "OutputMultiply")
		bonusTypesRecherches.append(atome.Name + "AttributsCostDivided")
		for attribut in atome.ListeAttribs:
			bonusTypesRecherches.append(atome.Name + attribut.Name + "CostDivided")
			bonusTypesRecherches.append(atome.Name + attribut.Name + "CoefficientMultiply")
	
	bonusTypesRecherches.append("AmeliorationsHeCostDivided")
	bonusTypesRecherches.append("AmeliorationHelium0CostDivided")
	bonusTypesRecherches.append("AmeliorationHelium3CostDivided")
	bonusTypesRecherches.append("AmeliorationsLithiumCostDivided")
	bonusTypesRecherches.append("AmeliorationLithium0CostDivided")
	bonusTypesRecherches.append("AmeliorationLithium1CostDivided")
	bonusTypesRecherches.append("MatiereNoireOutputMultiply")
	return bonusTypesRecherches
