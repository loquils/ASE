extends Node

var IsTutorialCompleted = false

var Coins = Big.new(0, 0)
var QuantiteesAtomes = {}

#Liste des atomes du jeu 
var AtomsListInitializingGame = []
#Dictionnaire de tous les atomes avec les états actuels (les clés sont les noms des atomes)
var ListeAtomes = {}

#Liste des recherches en initialisation
var ListeRechercheInitializeGame = []
#Liste de toutes les recherches
var ListeRecherches = []

#Liste des améliorations de l'helium en initialisation
var ListeAmeliorationsHeliumInitializeGame = []
#Liste de toutes les améliorations de l'helium 
var ListeAmeliorationsHelium = []

#Liste des recherches de matière noire en initialisation
var ListeRecherchesMatiereNoireInitializeGame = []
#Liste de toutes les améliorations de la dark matter
var ListeRecherchesMatiereNoire = []
var DarkMatter: Big = Big.new(0.0)

#Liste des améliorations du lithium en initialisation
var ListeAmeliorationsLithiumInitializeGame = []
#Liste de toutes les améliorations du Lithium 
var ListeAmeliorationsLithium = []

#Liste des améliorations du Beryllium en initialisation
var ListeAmeliorationsBerylliumInitializeGame = []
#Liste de toutes les améliorations du Beryllium 
var ListeAmeliorationsBeryllium = []

#Liste des améliorations du bore en initialisation
var ListeAmeliorationsBoreInitializeGame = []
#Liste de toutes les améliorations du Bore 
var ListeAmeliorationsBore = []

# Called when the n*ode enters the scene tree for the first time.
func _ready():
	BonusManager.BonusTypesRecherches = BonusManager.InitializeRecherchesBonusTypes()
	
	#Il faut load la sauvegarde si elle existe :)
	var ressourceLoadingGame = Save.load_game()
	
	var quantiteesAtomesInSaving
	var atomsListInSaving
	var listeRecherchesInSaving
	var listeAmeliorationsHeliumInSaving
	var listeAmeliorationsLithiumInSaving
	var listeAmeliorationsBerylliumInSaving
	var listeAmeliorationsBoreInSaving
	var listeRecherchesMatiereNoireInSaving

	if ressourceLoadingGame != null:
		if ressourceLoadingGame.has("Langue"):
			LangueManager.maj_langue(ressourceLoadingGame["Langue"])
		if ressourceLoadingGame.has("Coins"):
			Coins = Big.ToCustomFormat(ressourceLoadingGame["Coins"])
		if ressourceLoadingGame.has("AtomsQuantity"):
			quantiteesAtomesInSaving = ressourceLoadingGame["AtomsQuantity"]
		if ressourceLoadingGame.has("ListeAtomes"):
			atomsListInSaving = ressourceLoadingGame["ListeAtomes"]
		if ressourceLoadingGame.has("ResearchesList"):
			listeRecherchesInSaving = ressourceLoadingGame["ResearchesList"]
		if ressourceLoadingGame.has("HeliumUpgradesList"):
			listeAmeliorationsHeliumInSaving = ressourceLoadingGame["HeliumUpgradesList"]
		if ressourceLoadingGame.has("LithiumUpgradesList"):
			listeAmeliorationsLithiumInSaving = ressourceLoadingGame["LithiumUpgradesList"]
		if ressourceLoadingGame.has("BerylliumUpgradesList"):
			listeAmeliorationsBerylliumInSaving = ressourceLoadingGame["BerylliumUpgradesList"]
		if ressourceLoadingGame.has("BoreUpgradesList"):
			listeAmeliorationsBoreInSaving = ressourceLoadingGame["BoreUpgradesList"]
		if ressourceLoadingGame.has("DarkMatter"):
			DarkMatter = Big.ToCustomFormat(ressourceLoadingGame["DarkMatter"])
		if ressourceLoadingGame.has("RecherchesMatiereNoire"):
			listeRecherchesMatiereNoireInSaving = ressourceLoadingGame["RecherchesMatiereNoire"]
		if ressourceLoadingGame.has("InformationsPartie"):
			InfosPartie.Load(ressourceLoadingGame["InformationsPartie"])
		if ressourceLoadingGame.has("TutorialCompleted"):
			IsTutorialCompleted = ressourceLoadingGame["TutorialCompleted"]
	
	AtomsLoading(quantiteesAtomesInSaving, atomsListInSaving)
	LoadResearch(listeRecherchesInSaving)
	LoadAmeliorationHelium(listeAmeliorationsHeliumInSaving)
	LoadAmeliorationLithium(listeAmeliorationsLithiumInSaving)
	LoadAmeliorationBeryllium(listeAmeliorationsBerylliumInSaving)
	LoadAmeliorationBore(listeAmeliorationsBoreInSaving)
	LoadDarkMatter(listeRecherchesMatiereNoireInSaving)


#Permet de charger la liste des atomes, et des quantitees possedees
func AtomsLoading(quantiteesAtomesInSaving, atomsListInSaving):
	#On définit la liste de base des atomes (début du jeu)
	DefineAtomsListInitializingGame()
	
	#Pour chaque atome dans la liste du jeu
	for initializedAtom in AtomsListInitializingGame:
		#Si on a recupérer une liste d'atomes dans la sauvegarde et que l'atome existe dans la sauvegarde
		if atomsListInSaving != null and atomsListInSaving.has(initializedAtom.Name) and atomsListInSaving[initializedAtom.Name] != null:
			
			#Faut qu'on definnisse le niveau pour tous les attributs de l'atome
			for attributInitialized in initializedAtom.ListeAttribs:
				#On récupère le bon attribut de l'atome dans la liste de jeu
				var attributLevelInSave = atomsListInSaving[initializedAtom.Name]["Attributs"][attributInitialized.Name] 
				#Si il existe, il faut qu'on change le niveau
				if  attributLevelInSave != null:
					attributInitialized.Niveau = Big.ToCustomFormat(attributLevelInSave)
				#Et on multiplie le coefficient d'achat par 2 pour tous les 100 niveaux
			
			#Faut qu'on définisse si l'atome est débloqué ou pas
			var isAtomeUnlockedInSave = atomsListInSaving[initializedAtom.Name]["Unlock"]
			if isAtomeUnlockedInSave != null:
				if isAtomeUnlockedInSave:
					initializedAtom.isUnlocked = true
		
		#On récupère la quantité de l'atome aussi
		if quantiteesAtomesInSaving != null and quantiteesAtomesInSaving.has(initializedAtom.Name) and quantiteesAtomesInSaving[initializedAtom.Name] != null:
			QuantiteesAtomes[initializedAtom.Name] = Big.ToCustomFormat(quantiteesAtomesInSaving[initializedAtom.Name])
		else:
			QuantiteesAtomes[initializedAtom.Name] = Big.new(0.0)
	
	for initializedAtome in AtomsListInitializingGame:
		ListeAtomes[initializedAtome.Name] = initializedAtome


#Permet de charger la liste des recherches
func LoadResearch(listeRecherchesInSaving):
	#On définit la liste de base des recherches
	DefineResearchListInitializingGame()
	
	if not listeRecherchesInSaving == null:
		for initializedRecherche in ListeRechercheInitializeGame:
			#var IdRecherche = listeRecherchesInSaving.find(initializedRecherche)
			var recherchesTrouveeInSaving = listeRecherchesInSaving.filter(func(rechercheSave): return rechercheSave.Id == initializedRecherche.Id)
			if recherchesTrouveeInSaving.size() == 1:
				if recherchesTrouveeInSaving[0]["IsUnlocked"]:
					initializedRecherche.IsUnlocked = true
	
	for recherche in ListeRechercheInitializeGame:
		ListeRecherches.append(recherche)
	
	#BonusManager.MajBonusRecherches()


#Permet de charger la liste des recherches
func LoadAmeliorationHelium(listeAmeliorationsHeliumInSaving):
	DefineAmeliorationHeliumListInitializingGame()
	
	if not listeAmeliorationsHeliumInSaving == null:
		for initializedAmeliorationHelium in ListeAmeliorationsHeliumInitializeGame:
			if initializedAmeliorationHelium.Id < len(listeAmeliorationsHeliumInSaving) and not listeAmeliorationsHeliumInSaving[initializedAmeliorationHelium.Id] == null:
				if listeAmeliorationsHeliumInSaving[initializedAmeliorationHelium.Id]["IsUnlocked"]:
					initializedAmeliorationHelium.IsUnlocked = true
					initializedAmeliorationHelium.Level = Big.ToCustomFormat(listeAmeliorationsHeliumInSaving[initializedAmeliorationHelium.Id]["Level"])
	
	for ameliorationHelium in ListeAmeliorationsHeliumInitializeGame:
		ListeAmeliorationsHelium.append(ameliorationHelium)
	
	BonusManager.MajBonusAmeliorationHelium()


#Permet de charger la liste des amélioration de Lithium
func LoadAmeliorationLithium(listeAmeliorationsLithiumInSaving):
	DefineAmeliorationLithiumListInitializingGame()
	
	if not listeAmeliorationsLithiumInSaving == null:
		for initializedAmeliorationLithium in ListeAmeliorationsLithiumInitializeGame:
			if initializedAmeliorationLithium.Id < len(listeAmeliorationsLithiumInSaving) and not listeAmeliorationsLithiumInSaving[initializedAmeliorationLithium.Id] == null:
				if listeAmeliorationsLithiumInSaving[initializedAmeliorationLithium.Id]["IsUnlocked"]:
					initializedAmeliorationLithium.IsUnlocked = true
					initializedAmeliorationLithium.Level = Big.ToCustomFormat(listeAmeliorationsLithiumInSaving[initializedAmeliorationLithium.Id]["Level"])
	
	for ameliorationLithium in ListeAmeliorationsLithiumInitializeGame:
		ListeAmeliorationsLithium.append(ameliorationLithium)
	
	BonusManager.MajBonusAmeliorationLithium()


#Permet de charger la liste des amélioration de Beryllium
func LoadAmeliorationBeryllium(listeAmeliorationsBerylliumInSaving):
	DefineAmeliorationBerylliumListInitializingGame()
	
	if not listeAmeliorationsBerylliumInSaving == null:
		for initializedAmeliorationBeryllium in ListeAmeliorationsBerylliumInitializeGame:
			if initializedAmeliorationBeryllium.Id < len(listeAmeliorationsBerylliumInSaving) and not listeAmeliorationsBerylliumInSaving[initializedAmeliorationBeryllium.Id] == null:
				if listeAmeliorationsBerylliumInSaving[initializedAmeliorationBeryllium.Id]["IsUnlocked"]:
					initializedAmeliorationBeryllium.IsUnlocked = true
					initializedAmeliorationBeryllium.Level = Big.ToCustomFormat(listeAmeliorationsBerylliumInSaving[initializedAmeliorationBeryllium.Id]["Level"])
	
	for ameliorationBeryllium in ListeAmeliorationsBerylliumInitializeGame:
		ListeAmeliorationsBeryllium.append(ameliorationBeryllium)
	
	BonusManager.MajBonusAmeliorationBeryllium()


#Permet de charger la liste des amélioration de Lithium
func LoadAmeliorationBore(listeAmeliorationsBoreInSaving):
	DefineAmeliorationBoreListInitializingGame()
	
	if not listeAmeliorationsBoreInSaving == null:
		for initializedAmeliorationBore in ListeAmeliorationsBoreInitializeGame:
			if initializedAmeliorationBore.Id < len(listeAmeliorationsBoreInSaving) and not listeAmeliorationsBoreInSaving[initializedAmeliorationBore.Id] == null:
				if listeAmeliorationsBoreInSaving[initializedAmeliorationBore.Id]["IsUnlocked"]:
					initializedAmeliorationBore.IsUnlocked = true
					initializedAmeliorationBore.Level = Big.ToCustomFormat(listeAmeliorationsBoreInSaving[initializedAmeliorationBore.Id]["Level"])
	
	for ameliorationBore in ListeAmeliorationsBoreInitializeGame:
		ListeAmeliorationsBore.append(ameliorationBore)
	
	BonusManager.MajBonusAmeliorationBore()


#Permet de charger la liste des recherches de matière noire
func LoadDarkMatter(listeRecherchesMatiereNoireInSaving):
	DefineRechercheMatiereNoireListInitializingGame()

	if not listeRecherchesMatiereNoireInSaving == null:
		for initializedRechercheMatiereNoire in ListeRecherchesMatiereNoireInitializeGame:
			if initializedRechercheMatiereNoire.Id < len(listeRecherchesMatiereNoireInSaving) and not listeRecherchesMatiereNoireInSaving[initializedRechercheMatiereNoire.Id] == null:
				if listeRecherchesMatiereNoireInSaving[initializedRechercheMatiereNoire.Id]["IsUnlocked"]:
					initializedRechercheMatiereNoire.IsUnlocked = true
	
	for rechercheMatiereNoire in ListeRecherchesMatiereNoireInitializeGame:
		ListeRecherchesMatiereNoire.append(rechercheMatiereNoire)
	
	#BonusManager.MajBonusRecherchesMatiereNoire()


#Calcul et ajoute la quantité d'atome par rapport au temps indiqué
func CalculateQuantityAtomes(timeInSeconde:int = 1):
	for atome in ListeAtomes:
		if ListeAtomes[atome].isUnlocked:
				var quantityAtomeWithTime = Big.multiply(ListeAtomes[atome].GetAtomePerSec(), Big.new(timeInSeconde))
				QuantiteesAtomes[atome] = Big.add(QuantiteesAtomes[atome], quantityAtomeWithTime)


#Calcul et ajoute la quantité d'un atome par rapport au temps indiqué
func CalculateQuantityOneAtome(atomName, timeInSeconde:int = 1):
	if ListeAtomes[atomName].isUnlocked:
		var quantityAtomeWithTime = Big.multiply(ListeAtomes[atomName].GetAtomePerSec(), Big.new(timeInSeconde))
		return quantityAtomeWithTime


#---------------------------------Define all elements of the game !----------------------------------#

#Permet d'initialiser la liste des atomes dans le jeu
func DefineAtomsListInitializingGame():
	#On définit les atomes auxquels on a accès :)
	var hydrogeneAtom = Atome.new("Hydrogene", Big.new(1.0, 0), Big.new(1.0, 0))
	var attribut1Hydrogene = AttributAtome.new(hydrogeneAtom, "Force", Big.new(0.0), Big.new(1.11), Big.new(0.12), Big.new(5))
	var attribut2Hydrogene = AttributAtome.new(hydrogeneAtom, "Vitesse", Big.new(0.0), Big.new(1.34), Big.new(0.25), Big.new(10))
	var hydrogenAttributsList = [attribut1Hydrogene, attribut2Hydrogene]
	hydrogeneAtom.DefineAtomeAttributs(hydrogenAttributsList)
	hydrogeneAtom.isUnlocked = true
	AtomsListInitializingGame.append(hydrogeneAtom)
	
	var heliumAtom = Atome.new("Helium", Big.new(0.7, 0))
	var attribut1Helium = AttributAtome.new(heliumAtom, "Force", Big.new(0.0), Big.new(1.24), Big.new(0.10), Big.new(25))
	var attribut2Helium = AttributAtome.new(heliumAtom, "Rotation", Big.new(0.0), Big.new(1.36), Big.new(0.2), Big.new(60))
	var attribut3Helium = AttributAtome.new(heliumAtom, "Complexitee", Big.new(0.0), Big.new(1.82), Big.new(0.42), Big.new(100))
	var heliumAttributsList = [attribut1Helium, attribut2Helium, attribut3Helium]

	heliumAtom.DefineAtomeAttributs(heliumAttributsList)
	heliumAtom.DefineAtomeUnlockingPrice({"Hydrogene" : Big.new(1.5, 3)})
	AtomsListInitializingGame.append(heliumAtom)
	
	var lithiumAtom = Atome.new("Lithium", Big.new(0.25, 0))
	var attribut1Lithium = AttributAtome.new(lithiumAtom, "Lien", Big.new(0.0), Big.new(1.56), Big.new(0.25), Big.new(3.25, 2))
	var attribut2Lithium = AttributAtome.new(lithiumAtom, "Vitesse", Big.new(0.0), Big.new(1.1), Big.new(0.1), Big.new(5.0, 2))
	var attribut3Lithium = AttributAtome.new(lithiumAtom, "Vibration", Big.new(0.0), Big.new(1.34), Big.new(0.17), Big.new(1.0, 3))
	var lithiumAttributsList = [attribut1Lithium, attribut2Lithium, attribut3Lithium]

	lithiumAtom.DefineAtomeAttributs(lithiumAttributsList)
	lithiumAtom.DefineAtomeUnlockingPrice({"Helium" : Big.new(3.8, 3)})
	AtomsListInitializingGame.append(lithiumAtom)
	
	var berylliumAtom = Atome.new("Beryllium", Big.new(0.10, 0))
	var attribut1Beryllium = AttributAtome.new(berylliumAtom, "Force", Big.new(0.0), Big.new(1.45), Big.new(0.18), Big.new(1.75, 3))
	var attribut2Beryllium = AttributAtome.new(berylliumAtom, "Tension", Big.new(0.0), Big.new(2.25), Big.new(0.75), Big.new(4.0, 3))
	var attribut3Beryllium = AttributAtome.new(berylliumAtom, "Complexitee", Big.new(0.0), Big.new(1.68), Big.new(0.2), Big.new(1.0, 3))
	var berylliumAttributsList = [attribut1Beryllium, attribut2Beryllium, attribut3Beryllium]

	berylliumAtom.DefineAtomeAttributs(berylliumAttributsList)
	berylliumAtom.DefineAtomeUnlockingPrice({"Lithium" : Big.new(5.75, 3)})
	AtomsListInitializingGame.append(berylliumAtom)
	
	var boreAtom = Atome.new("Bore", Big.new(0.10, 0))
	var attribut1Bore = AttributAtome.new(boreAtom, "Tension", Big.new(0.0), Big.new(1.25), Big.new(0.19), Big.new(5.4, 3))
	var attribut2Bore = AttributAtome.new(boreAtom, "Vibration", Big.new(0.0), Big.new(1.17), Big.new(0.15), Big.new(3.2, 3))
	var boreAttributsList = [attribut1Bore, attribut2Bore]

	boreAtom.DefineAtomeAttributs(boreAttributsList)
	boreAtom.DefineAtomeUnlockingPrice({"Beryllium" : Big.new(9.25, 3)})
	AtomsListInitializingGame.append(boreAtom)


#Permet d'initialiser la liste des recherches dans le jeu
func DefineResearchListInitializingGame():
	var debutRecherche = Recherche.ResearchLevelEnum.DEBUT
	var easyRecherche = Recherche.ResearchLevelEnum.EASY
	var lessEasyRecherche = Recherche.ResearchLevelEnum.LESSEASY
	
	ListeRechercheInitializeGame.append(Recherche.new(0, "PRIXHYDROGENE", Big.new(1.5, 2), ["PrixHydrogeneAugmentation"], Big.new(0.25, 0), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(1, "PRIXHYDROGENE", Big.new(4.0, 2), ["PrixHydrogeneAugmentation"], Big.new(0.5, 0), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(8, "RENDEMENT", Big.new(1.0, 3), ["HydrogeneOutputMultiplyParRecherche"], Big.new(0.25), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(2, "PRIXHYDROGENE", Big.new(2.5, 3), ["PrixHydrogeneAugmentation"], Big.new(1.0, 0), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(3, "DIVIDE", Big.new(6.0, 3), ["HydrogeneAttributsCostDivided"], Big.new(3.0), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(11, "DIVIDE", Big.new(1.4, 4), ["HydrogeneVitesseCostDivided", "HeliumComplexiteeCostDivided"], Big.new(10.0), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(7, "RENDEMENT", Big.new(3.15, 4), ["AllOutputMultiplyParRecherche"], Big.new(0.08), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(4, "RENDEMENT", Big.new(7.55, 4), ["HydrogeneOutputMultiplyParRecherche", "HeliumOutputMultiplyParRecherche"], Big.new(0.1), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(5, "PRIXHYDROGENE", Big.new(1.8, 5), ["PrixHydrogeneAugmentation"], Big.new(3.0), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(12, "ATTRIBUTS", Big.new(4.0, 5), ["HydrogeneForceCoefficientMultiply", "HydrogeneVitesseCoefficientMultiply"], Big.new(0.2), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(9, "DIVIDE", Big.new(9.75, 5), ["HydrogeneAttributsCostDivided", "HeliumAttributsCostDivided"], Big.new(8.0), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(6, "RENDEMENT", Big.new(2.2, 6), ["HeliumOutputMultiply"], Big.new(0.75), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(10, "RENDEMENT", Big.new(5.25, 6), ["HydrogeneOutputMultiply", "HeliumOutputMultiply"], Big.new(0.5), debutRecherche))
	
	ListeRechercheInitializeGame.append(Recherche.new(21, "AMELIOHELIUM", Big.new(2.0, 7), ["AmeliorationHelium0CostDivided", "AmeliorationHelium3CostDivided"], Big.new(10), easyRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(13, "RENDEMENT", Big.new(7.0, 7), ["LithiumOutputMultiply"], Big.new(1.0), easyRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(14, "DIVIDE", Big.new(2.1, 8), ["LithiumAttributsCostDividedParRecherche", "BerylliumAttributsCostDividedParRecherche"], Big.new(3.0), easyRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(15, "RENDEMENT", Big.new(4.8, 8), ["HeliumOutputMultiply"], Big.new(2.0), easyRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(16, "RENDEMENT", Big.new(1.0, 9), ["AllOutputMultiplyParRecherche"], Big.new(0.25), easyRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(17, "RENDEMENT", Big.new(2.5, 9), ["MatiereNoireOutputMultiply"], Big.new(0.15), easyRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(18, "RENDEMENT", Big.new(6.7, 9), ["LithiumOutputMultiply","BerylliumOutputMultiply"], Big.new(0.8), easyRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(19, "DIVIDE", Big.new(2.0, 10), ["BoreAttributsCostDivided"], Big.new(8.0), easyRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(20, "RENDEMENT", Big.new(5.25, 10), ["HydrogeneOutputMultiplyParRecherche", "HeliumOutputMultiplyParRecherche", "LithiumOutputMultiplyParRecherche"], Big.new(0.5), easyRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(26, "DIVIDE", Big.new(1.8, 11), ["LithiumAttributsCostDivided", "BerylliumAttributsCostDivided"], Big.new(8.0), easyRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(22, "AMELIOLITHIUM", Big.new(3.75, 11), ["AmeliorationLithium0CostDivided", "AmeliorationLithium1CostDivided"], Big.new(5.0), easyRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(23, "RENDEMENT", Big.new(8.0, 11), ["RechercheOutputMultiply"], Big.new(0.2), easyRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(24, "DIVIDE", Big.new(1.75, 12), ["HeliumAttributsCoefficientMultiply"], Big.new(1.0), easyRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(25, "RENDEMENT", Big.new(4.0, 12), ["BerylliumOutputMultiply", "BoreOutputMultiply"], Big.new(1.0), easyRecherche))


#Permet d'initialiser la liste des amélioration de l'hélium dans le jeu
func DefineAmeliorationHeliumListInitializingGame():
	var ameliorationHeliumPression1 = AmeliorationHelium.new(0, "AMELIORATIONHELIUM1", "AMELIORATIONHELIUMPRESSIONDESCRIPTION1", Big.new(1.0, 2), Big.new(1.3), AmeliorationHelium.TypeAmeliorationHeliumEnum.Pression, "HydrogeneOutputMultiply", Big.new(0.05), true)
	ameliorationHeliumPression1.DefineAtomeUnlockingPrice( {"Helium" : Big.new(0.0)})
	ListeAmeliorationsHeliumInitializeGame.append(ameliorationHeliumPression1)
	
	var ameliorationHeliumPression2 = AmeliorationHelium.new(1, "AMELIORATIONHELIUM2", "AMELIORATIONHELIUMPRESSIONDESCRIPTION2", Big.new(1.0, 3), Big.new(2.75), AmeliorationHelium.TypeAmeliorationHeliumEnum.Pression, "PressionEfficacitee0", Big.new(0.1))
	ameliorationHeliumPression2.DefineAtomeUnlockingPrice( {"Helium" : Big.new(5.0, 3)})
	ListeAmeliorationsHeliumInitializeGame.append(ameliorationHeliumPression2)
	
	var ameliorationHeliumPression3 = AmeliorationHelium.new(2, "AMELIORATIONHELIUM3", "AMELIORATIONHELIUMPRESSIONDESCRIPTION3", Big.new(2.0, 5), Big.new(5.0), AmeliorationHelium.TypeAmeliorationHeliumEnum.Pression, "PressionEfficacitee1", Big.new(0.25))
	ameliorationHeliumPression3.DefineAtomeUnlockingPrice( {"Helium" : Big.new(1.0, 6)})
	ListeAmeliorationsHeliumInitializeGame.append(ameliorationHeliumPression3)
	
	
	var ameliorationHeliumTemperature1 = AmeliorationHelium.new(3, "AMELIORATIONHELIUM4", "AMELIORATIONHELIUMTEMPERATUREDESCRIPTION1", Big.new(5.0, 2), Big.new(1.55), AmeliorationHelium.TypeAmeliorationHeliumEnum.Temperature, "HydrogeneAttributsCoefficientAdd", Big.new(0.008))
	ameliorationHeliumTemperature1.DefineAtomeUnlockingPrice( {"Helium" : Big.new(1.0, 3)})
	ListeAmeliorationsHeliumInitializeGame.append(ameliorationHeliumTemperature1)
	
	var ameliorationHeliumTemperature2 = AmeliorationHelium.new(4, "AMELIORATIONHELIUM5", "AMELIORATIONHELIUMTEMPERATUREDESCRIPTION2", Big.new(1.0, 4), Big.new(3.5), AmeliorationHelium.TypeAmeliorationHeliumEnum.Temperature, "TemperatureEfficacitee0", Big.new(0.025))
	ameliorationHeliumTemperature2.DefineAtomeUnlockingPrice( {"Helium" : Big.new(2.5, 4)})
	ListeAmeliorationsHeliumInitializeGame.append(ameliorationHeliumTemperature2)
	
	var ameliorationHeliumTemperature3 = AmeliorationHelium.new(5, "AMELIORATIONHELIUM6", "AMELIORATIONHELIUMTEMPERATUREDESCRIPTION3", Big.new(2.5, 6), Big.new(7.0), AmeliorationHelium.TypeAmeliorationHeliumEnum.Temperature, "TemperatureEfficacitee1", Big.new(0.1))
	ameliorationHeliumTemperature3.DefineAtomeUnlockingPrice( {"Helium" : Big.new(8.0, 6)})
	ListeAmeliorationsHeliumInitializeGame.append(ameliorationHeliumTemperature3)


#Permet d'initialiser la liste des amélioration du lithium dans le jeu
func DefineAmeliorationLithiumListInitializingGame():
	var ameliorationLithiumProton = AmeliorationLithium.new(0, "Proton", "AMELIORATIONLITHIUMPROTONDESCRIPTION", Big.new(1.0, 2), Big.new(1.8), AmeliorationLithium.CategorieAmeliorationLithiumEnum.Proton, "HeliumOutputMultiply", Big.new(0.05), true)
	ameliorationLithiumProton.DefineUnlockingPrice( {"Lithium" : Big.new(1.0, 0)})
	ListeAmeliorationsLithiumInitializeGame.append(ameliorationLithiumProton)
	
	var ameliorationLithiumNeutron = AmeliorationLithium.new(1, "Neutron", "AMELIORATIONLITHIUMNEUTRONDESCRIPTION", Big.new(3.0, 2), Big.new(1.8), AmeliorationLithium.CategorieAmeliorationLithiumEnum.Neutron, "HeliumAttributsCostDivided", Big.new(0.2))
	ameliorationLithiumNeutron.DefineUnlockingPrice( {"Lithium" : Big.new(1.0, 3)})
	ListeAmeliorationsLithiumInitializeGame.append(ameliorationLithiumNeutron)
	
	var ameliorationLithiumElectronK1 = AmeliorationLithium.new(2, "ElectronK1", "AMELIORATIONLITHIUMELECTRONK1DESCRIPTION", Big.new(3.0, 3), Big.new(3.6), AmeliorationLithium.CategorieAmeliorationLithiumEnum.ElectronK, "ProtonEfficacitee", Big.new(0.05))
	ameliorationLithiumElectronK1.DefineUnlockingPrice( {"Lithium" : Big.new(1.0, 4)})
	ListeAmeliorationsLithiumInitializeGame.append(ameliorationLithiumElectronK1)
	
	var ameliorationLithiumElectronK2 = AmeliorationLithium.new(3, "ElectronK2", "AMELIORATIONLITHIUMELECTRONK2DESCRIPTION", Big.new(7.5, 3), Big.new(3.6), AmeliorationLithium.CategorieAmeliorationLithiumEnum.ElectronK, "NeutronEfficacitee", Big.new(0.2))
	ameliorationLithiumElectronK2.DefineUnlockingPrice( {"Lithium" : Big.new(2.5, 4)})
	ListeAmeliorationsLithiumInitializeGame.append(ameliorationLithiumElectronK2)
	
	var ameliorationLithiumElectronL1 = AmeliorationLithium.new(4, "ElectronL1", "AMELIORATIONLITHIUMELECTRONLDESCRIPTION", Big.new(3.0, 6), Big.new(7.5), AmeliorationLithium.CategorieAmeliorationLithiumEnum.ElectronL, "ElectronsKEfficacitee", Big.new(0.25))
	ameliorationLithiumElectronL1.DefineUnlockingPrice( {"Lithium" : Big.new(6.0, 6)})
	ListeAmeliorationsLithiumInitializeGame.append(ameliorationLithiumElectronL1)


#Permet d'initialiser la liste des amélioration du Beryllium dans le jeu
func DefineAmeliorationBerylliumListInitializingGame():
	var ameliorationBerylliumHydrogene = AmeliorationBeryllium.new(0, "Hydrogene", "AMELIORATIONBERYLLIUMHYDROGENEDESCRIPTION", {"Hydrogene" : Big.new(1.0, 2)}, Big.new(1.5), AmeliorationBeryllium.CategorieAmeliorationBerylliumEnum.Normal, [1, 1, 0, 0], true)
	ameliorationBerylliumHydrogene.DefineUnlockingPrice( {"Beryllium" : Big.new(1.0, 0)})
	ListeAmeliorationsBerylliumInitializeGame.append(ameliorationBerylliumHydrogene)
	
	var ameliorationBerylliumHelium = AmeliorationBeryllium.new(1, "Helium", "AMELIORATIONBERYLLIUMHELIUMDESCRIPTION", {"Helium" : Big.new(2.0, 2)}, Big.new(1.6), AmeliorationBeryllium.CategorieAmeliorationBerylliumEnum.Normal, [1, 1, 1, 0], true)
	ameliorationBerylliumHelium.DefineUnlockingPrice( {"Beryllium" : Big.new(1.0, 0)})
	ListeAmeliorationsBerylliumInitializeGame.append(ameliorationBerylliumHelium)
	
	var ameliorationBerylliumLithium = AmeliorationBeryllium.new(2, "Lithium", "AMELIORATIONBERYLLIUMLITHIUMDESCRIPTION", {"Lithium" : Big.new(3.0, 2)}, Big.new(1.7), AmeliorationBeryllium.CategorieAmeliorationBerylliumEnum.Normal, [1, 1, 1, 1])
	ameliorationBerylliumLithium.DefineUnlockingPrice( {"Beryllium" : Big.new(1.0, 3)})
	ListeAmeliorationsBerylliumInitializeGame.append(ameliorationBerylliumLithium)
	
	var ameliorationBerylliumBeryllium = AmeliorationBeryllium.new(3, "Beryllium", "AMELIORATIONBERYLLIUMBERYLLIUMDESCRIPTION", {"Beryllium" : Big.new(8.0, 4)}, Big.new(2.25), AmeliorationBeryllium.CategorieAmeliorationBerylliumEnum.BonusAdd, [1, 0.5 , 0.25, 0.12])
	ameliorationBerylliumBeryllium.DefineUnlockingPrice( {"Beryllium" : Big.new(2.5, 5)})
	ListeAmeliorationsBerylliumInitializeGame.append(ameliorationBerylliumBeryllium)


#Permet d'initialiser la liste des amélioration du bore dans le jeu
func DefineAmeliorationBoreListInitializingGame():
	var ameliorationBoreBery1 = AmeliorationBore.new(0, "AMELIORATIONBORE0NOM", "AMELIORATIONBORE0DESCRIPTION", Big.new(1.5, 2), Big.new(1.6), AmeliorationBore.TypeAmeliorationBoreEnum.Classic, "QuantiteeMatiere", Big.new(1), true)
	ameliorationBoreBery1.DefineAtomeUnlockingPrice( {"Bore" : Big.new(1.0, 0)})
	ListeAmeliorationsBoreInitializeGame.append(ameliorationBoreBery1)
	
	var ameliorationBoreBery2 = AmeliorationBore.new(1, "AMELIORATIONBORE1NOM", "AMELIORATIONBORE1DESCRIPTION", Big.new(4.0, 2), Big.new(2.5), AmeliorationBore.TypeAmeliorationBoreEnum.Classic, "BonusQuantiteeMatiere", Big.new(0.25))
	ameliorationBoreBery2.DefineAtomeUnlockingPrice( {"Bore" : Big.new(1.0, 3)})
	ListeAmeliorationsBoreInitializeGame.append(ameliorationBoreBery2)
	
	var ameliorationBoreBaseBonus = AmeliorationBore.new(2, "AMELIORATIONBORE2NOM", "AMELIORATIONBORE2DESCRIPTION", Big.new(3.0, 3), Big.new(1.9), AmeliorationBore.TypeAmeliorationBoreEnum.Advanced, "AmeliorationBoreBonusBeryllium", Big.new(0.25), true)
	ameliorationBoreBaseBonus.DefineAtomeUnlockingPrice( {"Bore" : Big.new(1.0, 0)})
	ListeAmeliorationsBoreInitializeGame.append(ameliorationBoreBaseBonus)
	
	var ameliorationBoreDMBaseBonus = AmeliorationBore.new(3, "AMELIORATIONBORE3NOM", "AMELIORATIONBORE3DESCRIPTION", Big.new(2.5, 4), Big.new(3.0), AmeliorationBore.TypeAmeliorationBoreEnum.Advanced, "AmeliorationBoreBonusDarkMatter", Big.new(1))
	ameliorationBoreDMBaseBonus.DefineAtomeUnlockingPrice( {"Bore" : Big.new(1.575, 5)})
	ListeAmeliorationsBoreInitializeGame.append(ameliorationBoreDMBaseBonus)


#Permet d'initialiser la liste des recherches de matière noire dans le jeu
func DefineRechercheMatiereNoireListInitializingGame():
	var dmRecherche = Recherche.ResearchLevelEnum.DARKMATTER
	ListeRecherchesMatiereNoireInitializeGame.append(Recherche.new(0, "RECHERCHEMATIERENOIRE1", Big.new(1.0, 0), ["HydrogeneOutputMultiplyParRechercheMN", "HeliumOutputMultiplyParRechercheMN"], Big.new(1.0, 0), dmRecherche))
	ListeRecherchesMatiereNoireInitializeGame.append(Recherche.new(1, "RECHERCHEMATIERENOIRE2", Big.new(1.0, 1), ["HydrogeneAttributsCostDividedParRechercheMN"], Big.new(2.0, 1), dmRecherche))
	ListeRecherchesMatiereNoireInitializeGame.append(Recherche.new(2, "RECHERCHEMATIERENOIRE3", Big.new(1.0, 2), ["HydrogeneOutputMultiply", "HeliumOutputMultiply"], Big.new(2.0, 0), dmRecherche))
	ListeRecherchesMatiereNoireInitializeGame.append(Recherche.new(3, "RECHERCHEMATIERENOIRE4", Big.new(1.0, 3), ["AmeliorationsHeCostDividedParRechercheMN"], Big.new(1.0, 1), dmRecherche))
	ListeRecherchesMatiereNoireInitializeGame.append(Recherche.new(4, "PRIXHYDROGENE", Big.new(1.0, 4), ["PrixHydrogeneAugmentation"], Big.new(3.0, 2), dmRecherche))
	ListeRecherchesMatiereNoireInitializeGame.append(Recherche.new(5, "RENDEMENT", Big.new(1.0, 5), ["HydrogeneOutputMultiplyParRechercheMN", "HeliumOutputMultiplyParRechercheMN", "LithiumOutputMultiplyParRechercheMN", "BerylliumOutputMultiplyParRechercheMN"], Big.new(0.75), dmRecherche))
	ListeRecherchesMatiereNoireInitializeGame.append(Recherche.new(6, "DIVIDED", Big.new(1.0, 6), ["HeliumAttributsCostDividedParRechercheMN", "LithiumAttributsCostDividedParRechercheMN"], Big.new(5.0, 1), dmRecherche))
	ListeRecherchesMatiereNoireInitializeGame.append(Recherche.new(6, "RENDEMENT", Big.new(1.0, 7), ["AmeliorationHelium0OutputMultiply"], Big.new(0.2), dmRecherche))
	

#----------------------------------------------Réinitialisation--------------------------------------------------------#

#Permet de remettre les atomes à zero.
func ResetAtomes():
	for atome in ListeAtomes:
		for attribut in ListeAtomes[atome].ListeAttribs:
			attribut.Niveau = Big.new(0.0)
	
		if not atome == "Hydrogene":
			ListeAtomes[atome].isUnlocked = false


#Permet de remettre la quantitée des atomes à zero.
func ResetRessources():
	Coins = Big.new(0.0)
	for atomeNom in ListeAtomes:
		QuantiteesAtomes[atomeNom] = Big.new(0.0)


#Permet de remettre les recherches à zero.
func ResetRecherches():
	for recherche in ListeRecherches:
		recherche.IsUnlocked = false
	BonusManager.MajBonusRecherches()


#Permet de remettre les améliorations Helium à zero.
func ResetAmeliorationsHelium():
	for ameliorationHelium in ListeAmeliorationsHelium:
		ameliorationHelium.Level = Big.new(0.0)
		if not ameliorationHelium.IsBasedUnlocked:
			ameliorationHelium.IsUnlocked = false
	BonusManager.MajBonusAmeliorationHelium()


#Permet de remettre les améliorations Lithium à zero.
func ResetAmeliorationsLithium():
	for ameliorationLithium in ListeAmeliorationsLithium:
		ameliorationLithium.Level = Big.new(0.0)
		if not ameliorationLithium.IsBasedUnlocked:
			ameliorationLithium.IsUnlocked = false
	BonusManager.MajBonusAmeliorationLithium()


#Permet de remettre les améliorations Beryllium à zero.
func ResetAmeliorationsBeryllium():
	for ameliorationBeryllium in ListeAmeliorationsBeryllium:
		ameliorationBeryllium.Level = Big.new(0.0)
		if not ameliorationBeryllium.IsBasedUnlocked:
			ameliorationBeryllium.IsUnlocked = false
	BonusManager.MajBonusAmeliorationBeryllium()


#Permet de remettre les améliorations Bore à zero.
func ResetAmeliorationsBore():
	for ameliorationBore in ListeAmeliorationsBore:
		ameliorationBore.Level = Big.new(0.0)
		if not ameliorationBore.IsBasedUnlocked:
			ameliorationBore.IsUnlocked = false
	BonusManager.MajBonusAmeliorationBore()


#Permet de trigger le reset de toutes les améliorations.
func ResetToutesAmeliorations():
	ResetAmeliorationsHelium()
	ResetAmeliorationsLithium()
	ResetAmeliorationsBeryllium()
	ResetAmeliorationsBore()

#----------------------------------------------Sauvegarde--------------------------------------------------------#

#Permet de Save les données du jeu en cours.
func save():
	#Pour les quantitées
	var atomsQuantityDictionnary = {}
	for atomName in QuantiteesAtomes:
		atomsQuantityDictionnary[atomName] = QuantiteesAtomes[atomName].ToJsonFormat()
	
	#Pour les atomes
	var atomsDictionnary = {}
	for atomeName in ListeAtomes:
		var attributsDictionnary = {}
		for attributs in ListeAtomes[atomeName].ListeAttribs:
			attributsDictionnary[attributs.Name] = attributs.Niveau.ToJsonFormat()
		atomsDictionnary[atomeName] = {"Attributs" : attributsDictionnary, "Unlock" : ListeAtomes[atomeName].isUnlocked}
		
	#Pour les recherches
	var recherchesListe = []
	for recherche in ListeRecherches:
		recherchesListe.append({"Id" : recherche.Id, "IsUnlocked" : recherche.IsUnlocked})
	
	#Pour les améliorations de l'helium
	var ameliorationHeliumList = []
	for ameliorationHelium in ListeAmeliorationsHelium:
		ameliorationHeliumList.append({"Id" : ameliorationHelium.Id, "IsUnlocked" : ameliorationHelium.IsUnlocked, "Level" : ameliorationHelium.Level.ToJsonFormat()})
	
	#Pour les améliorations du lithium
	var ameliorationLithiumList = []
	for ameliorationLithium in ListeAmeliorationsLithium:
		ameliorationLithiumList.append({"Id" : ameliorationLithium.Id, "IsUnlocked" : ameliorationLithium.IsUnlocked, "Level" : ameliorationLithium.Level.ToJsonFormat()})
	
	#Pour les améliorations du Beryllium
	var ameliorationBerylliumList = []
	for ameliorationBeryllium in ListeAmeliorationsBeryllium:
		ameliorationBerylliumList.append({"Id" : ameliorationBeryllium.Id, "IsUnlocked" : ameliorationBeryllium.IsUnlocked, "Level" : ameliorationBeryllium.Level.ToJsonFormat()})

		#Pour les améliorations du Bore
	var ameliorationBoreList = []
	for ameliorationBore in ListeAmeliorationsBore:
		ameliorationBoreList.append({"Id" : ameliorationBore.Id, "IsUnlocked" : ameliorationBore.IsUnlocked, "Level" : ameliorationBore.Level.ToJsonFormat()})

	#Pour les recherches de matière noire
	var recherchesMatiereNoireListe = []
	for rechercheMatiereNoire in ListeRecherchesMatiereNoire:
		recherchesMatiereNoireListe.append({"Id" : rechercheMatiereNoire.Id, "IsUnlocked" : rechercheMatiereNoire.IsUnlocked})
	
	var save_dict = {
		"Langue" : LangueManager.languageCourrant,
		"Coins" : Coins.ToJsonFormat(),
		"AtomsQuantity" : atomsQuantityDictionnary,
		"ListeAtomes" : atomsDictionnary,
		"ResearchesList" : recherchesListe,
		"HeliumUpgradesList" : ameliorationHeliumList,
		"LithiumUpgradesList" : ameliorationLithiumList,
		"BerylliumUpgradesList" : ameliorationBerylliumList,
		"BoreUpgradesList" : ameliorationBoreList,
		"DarkMatter" : DarkMatter.ToJsonFormat(),
		"RecherchesMatiereNoire" : recherchesMatiereNoireListe,
		"InformationsPartie" : InfosPartie.Save(),
		"TutorialCompleted" : IsTutorialCompleted
	}
	
	return save_dict
