extends Node
#Force/Vitesse | Spin/Angle/Complexity
#Bonus des Recherches
var BonusTypesRecherches = ["PrixHydrogeneAugmentation", "AllOutputMultiply", "HydrogeneOutputMultiply", "HeliumOutputMultiply", "HydrogeneAttributsCostDivided", "HydrogeneForceCostDivided", "HydrogeneVitesseCostDivided", "HeliumAttributsCostDivided", "HeliumSpinCostDivided", "HeliumAngleCostDivided", "HeliumComplexiteeCostDivided", "HydrogeneForceCoefficientMultiply", "HydrogeneVitesseCoefficientMultiply"]
var CurrentBonusesRecherches = {}

#Amélioration de l'helium
var BonusTypesAmeliorationHelium = ["HydrogeneOutputMultiply", "HydrogeneAttributsCoefficientAdd", "PressionEfficacitee0", "PressionEfficacitee1","TemperatureEfficacitee0", "TemperatureEfficacitee1"]
var CurrentBonusesAmeliorationHelium = {}

#Amélioration du lithium
var BonusTypesAmeliorationLithium = ["HeliumOutputMultiply", "HeliumAttributsCostDivided" , "ProtonEfficacitee", "NeutronEfficacitee", "ElectronsKEfficacitee"]
var CurrentBonusesAmeliorationLithium = {}

#Bonus recherches matière noire
var BonusTypesRecherchesMatiereNoire = ["HydrogeneOutputMultiply", "HeliumOutputMultiply", "HydrogeneAttributsCostDivided"]
var CurrentBonusesRecherchesMatiereNoire = {}

func _ready():
	if len(CurrentBonusesRecherches) == 0:
		for bonusType in BonusTypesRecherches:
			CurrentBonusesRecherches[bonusType] = Big.new(0.0)
	
	if len(CurrentBonusesAmeliorationHelium) == 0:
		for bonusType in BonusTypesAmeliorationHelium:
			CurrentBonusesAmeliorationHelium[bonusType] = Big.new(0.0)
	
	if len(CurrentBonusesAmeliorationLithium) == 0:
		for bonusType in BonusTypesAmeliorationLithium:
			CurrentBonusesAmeliorationLithium[bonusType] = Big.new(0.0)
	
	if len(CurrentBonusesRecherchesMatiereNoire) == 0:
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


#Mise à jour des bonus des recherches de matière noire
func MajBonusRecherchesMatiereNoire():
	InfosPartie.MajInformationsPartie()
	
	for bonusTypeRecherchesMatiereNoire in BonusTypesRecherchesMatiereNoire:
		CurrentBonusesRecherchesMatiereNoire[bonusTypeRecherchesMatiereNoire] = Big.new(0.0)
		
	for rechercheMatiereNoire in RessourceManager.ListeRecherchesMatiereNoire:
		if rechercheMatiereNoire.IsUnlocked:
			#On check si on a une recherche en fonction de la quantité de recherche achetée, faudra changer ça je pense
			if rechercheMatiereNoire.Augmentation.contains("ParRechercheMN"):
				CurrentBonusesRecherchesMatiereNoire[rechercheMatiereNoire.Augmentation.replace("ParRechercheMN", "")] = Big.add(CurrentBonusesRecherchesMatiereNoire[rechercheMatiereNoire.Augmentation.replace("ParRechercheMN", "")], Big.multiply(rechercheMatiereNoire.AugmentationPercent, InfosPartie.RecherchesMatiereNoireAchetees))
			else:
				CurrentBonusesRecherchesMatiereNoire[rechercheMatiereNoire.Augmentation] = Big.add(CurrentBonusesRecherchesMatiereNoire[rechercheMatiereNoire.Augmentation], rechercheMatiereNoire.AugmentationPercent)

#Permet de récupérer le multiplicateur global du rendu des atomes (prend en compte les recherches et les amélioration Helium/Lithium
func GetGlobalMultiplicator(Name):
	var recherchesMultiplicator = Big.new(0.0)
	var heliumMultiplicator = Big.new(0.0)
	var lithiumMultiplicateur = Big.new(0.0)
	
	for CurrentResearchBonus in CurrentBonusesRecherches:
		if (CurrentResearchBonus.contains(Name) and CurrentResearchBonus.contains("OutputMultiply")) or CurrentResearchBonus.contains("AllOutputMultiply"):
			recherchesMultiplicator = Big.add(recherchesMultiplicator, CurrentBonusesRecherches[CurrentResearchBonus])
	
	for CurrentBonus in CurrentBonusesAmeliorationHelium:
		if CurrentBonus.contains(Name) and CurrentBonus.contains("OutputMultiply"):
			heliumMultiplicator = Big.add(heliumMultiplicator, GetAmeliorationHeliumCoefficientSortieAvecNiveau())
	
	for currentBonusAmeliorationLithiumBonus in CurrentBonusesAmeliorationLithium:
		if currentBonusAmeliorationLithiumBonus.contains(Name) and currentBonusAmeliorationLithiumBonus.contains("OutputMultiply"):
			lithiumMultiplicateur = Big.add(lithiumMultiplicateur, GetAmeliorationLithiumCoefficientProtonAvecNiveau())
	
	var globalMultiplicator = Big.add(lithiumMultiplicateur, Big.add(recherchesMultiplicator, heliumMultiplicator))
	
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

