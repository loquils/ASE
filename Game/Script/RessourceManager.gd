extends Node

var Coins = Big.new(0, 0)
var QuantiteesAtomes = {}

#Liste des atomes du jeu 
var AtomsListInitializingGame = []
#Dictionnaire de tous les atomes avec les états actuels (les clés sont les noms des atomes)
var AtomsList = {}


var listeRechercheInitializeGame = []
#Liste de toutes les recherches
var ListeRecherches = []


#Liste de toutes les améliorations de l'helium 
var ListeAmeliorationsHelium = []


#Liste de toutes les améliorations de la dark matter
var ListeAmeliorationsDarkMatter = []
var DarkMatter: Big = Big.new(0.0)
var HydrogeneMax: Big = Big.new(0.0)

# Called when the n*ode enters the scene tree for the first time.
func _ready():
	#Il faut load la sauvegarde si elle existe :)
	var ressourceLoadingGame = Save.load_game()
	
	var quantiteesAtomesInSaving
	var atomsListInSaving
	var listeRecherchesInSaving
	var listeAmeliorationsHeliumInSaving

	if ressourceLoadingGame != null:
		if ressourceLoadingGame.has("Langue"):
			LangueManager.maj_langue(ressourceLoadingGame["Langue"])
		if ressourceLoadingGame.has("Coins"):
			Coins = Big.ToCustomFormat(ressourceLoadingGame["Coins"])
		if ressourceLoadingGame.has("AtomsQuantity"):
			quantiteesAtomesInSaving = ressourceLoadingGame["AtomsQuantity"]
		if ressourceLoadingGame.has("AtomsList"):
			atomsListInSaving = ressourceLoadingGame["AtomsList"]
		if ressourceLoadingGame.has("ResearchesList"):
			listeRecherchesInSaving = ressourceLoadingGame["ResearchesList"]
		if ressourceLoadingGame.has("HeliumUpgradesList"):
			listeAmeliorationsHeliumInSaving = ressourceLoadingGame["HeliumUpgradesList"]

	
	AtomsLoading(quantiteesAtomesInSaving, atomsListInSaving)
	loadResearch(listeRecherchesInSaving)
	loadAmeliorationHelium(listeAmeliorationsHeliumInSaving)
	loadDarkMatter()



#Permet de charger la liste des atomes, et des quantitees possedees
func AtomsLoading(quantiteesAtomesInSaving, atomsListInSaving):
	#On définit la liste de base des atomes (début du jeu)
	DefineAtomsListInitializingGame()
	
	#Pour chaque atome dans la liste du jeu
	for initializedAtom in AtomsListInitializingGame:
		#Si on a recupérer une liste d'atomes dans la sauvegarde et que l'atome existe dans la sauvegarde
		if atomsListInSaving != null and atomsListInSaving[initializedAtom.Name] != null:
			
			#Faut qu'on definnisse le niveau pour tous les attributs de l'atome
			for attributInitialized in initializedAtom.ListeAttribs:
				#On récupère le bon attribut de l'atome dans la liste de jeu
				var attributLevelInSave = atomsListInSaving[initializedAtom.Name]["Attributs"][attributInitialized.Name] 
				#Si il existe, il faut qu'on change le niveau
				if  attributLevelInSave != null:
					attributInitialized.Niveau = Big.ToCustomFormat(attributLevelInSave)
			
			#Faut qu'on définisse si l'atome est débloqué ou pas
			var isAtomeUnlockedInSave = atomsListInSaving[initializedAtom.Name]["Unlock"]
			if isAtomeUnlockedInSave != null:
				if isAtomeUnlockedInSave:
					initializedAtom.isUnlocked = true
		
		#On récupère la quantité de l'atome aussi
		if quantiteesAtomesInSaving != null and quantiteesAtomesInSaving[initializedAtom.Name] != null:
			QuantiteesAtomes[initializedAtom.Name] = Big.ToCustomFormat(quantiteesAtomesInSaving[initializedAtom.Name])
		else:
			QuantiteesAtomes[initializedAtom.Name] = Big.new(0.0)
	
	for initializedAtome in AtomsListInitializingGame:
		AtomsList[initializedAtome.Name] = initializedAtome



#Permet de charger la liste des recherches
func loadResearch(listeRecherchesInSaving):
	#On définit la liste de base des recherches
	DefineResearchListInitializingGame()
	
	if not listeRecherchesInSaving == null:
		for initializedRecherche in listeRechercheInitializeGame:
			if initializedRecherche.Id < len(listeRecherchesInSaving) and not listeRecherchesInSaving[initializedRecherche.Id] == null:
				if listeRecherchesInSaving[initializedRecherche.Id]["IsUnlocked"]:
					initializedRecherche.IsUnlocked = true
			
	for recherche in listeRechercheInitializeGame:
		ListeRecherches.append(recherche)



#Permet de charger la liste des recherches
func loadAmeliorationHelium(listeAmeliorationsHeliumInSaving):
	var listeAmeliorationsHeliumInitializeGame = []
	var amelio1 = AmeliorationHelium.new(0, "PressionBu", "Multiplie par 2 le rendement d'hydrogène par seconde.", AmeliorationHelium.TypeAmeliorationHeliumEnum.Pression, "HydrogeneRendementMultiply", Big.new(2.0, 0))
	amelio1.DefineAtomeUnlockingPrice( {"Coins" : Big.new(5.0, 3)})
	listeAmeliorationsHeliumInitializeGame.append(amelio1)
	
	var amelio2 = AmeliorationHelium.new(1, "Coin3", "Améliore des trucs autre.", AmeliorationHelium.TypeAmeliorationHeliumEnum.Temperature, "HydrogeneAttributsCoefficientAdd", Big.new(0.01, 0))
	amelio2.DefineAtomeUnlockingPrice( {"Coins" : Big.new(1.0, 3)})
	amelio2.IsUnlocked = true
	listeAmeliorationsHeliumInitializeGame.append(amelio2)
	#listeAmeliorationsHeliumInitializeGame.append(AmeliorationHelium.new(1, "Coin2", "Améliore d'autre trucs.", AmeliorationHelium.TypeAmeliorationHeliumEnum.Pression, "HydrogeneRendementMultiply", CustomNumber.new(2.0, 0)))
	#listeAmeliorationsHeliumInitializeGame.append(AmeliorationHelium.new(3, "Coin4", "Améliore d'autre trucs des autres.", AmeliorationHelium.TypeAmeliorationHeliumEnum.Temperature, "HydrogeneRendementMultiply", CustomNumber.new(2.0, 0)))
	
	if not listeAmeliorationsHeliumInSaving == null:
		for initializedAmeliorationHelium in listeAmeliorationsHeliumInitializeGame:
			if not listeAmeliorationsHeliumInSaving[initializedAmeliorationHelium.Id] == null:
				if listeAmeliorationsHeliumInSaving[initializedAmeliorationHelium.Id]["IsUnlocked"]:
					initializedAmeliorationHelium.IsUnlocked = true
					initializedAmeliorationHelium.Level = Big.ToCustomFormat(listeAmeliorationsHeliumInSaving[initializedAmeliorationHelium.Id]["Level"])
	
	for ameliorationHelium in listeAmeliorationsHeliumInitializeGame:
		ListeAmeliorationsHelium.append(ameliorationHelium)



func loadDarkMatter():
	var darkMatter1 = AmeliorationDarkMatter.new(0, "Evolution Hydrogène", "Double l'apport d'hydrogène par seconde.", Big.new(20.0, 0), Big.new(2.0, 0))
	ListeAmeliorationsDarkMatter.append(darkMatter1)


#Calcul et ajoute la quantité d'atome à la quantité d'atome
func CalculateQuantityAtomes(timeInSeconde:int = 1):
	for atome in AtomsList:
		if AtomsList[atome].isUnlocked:
				QuantiteesAtomes[atome] = Big.multiply(Big.add(QuantiteesAtomes[atome], AtomsList[atome].GetAtomePerSec()), Big.new(timeInSeconde))


#Permet d'initialiser la liste des atomes dans le jeu
func DefineAtomsListInitializingGame():
		#On définit les atomes auxquels on a accès :)
	var hydrogeneAtom = Atome.new("Hydrogene", Big.new(1.0, 0), Big.new(1.0, 0))
	var hydrogenAttributsList = [AttributAtome.new(hydrogeneAtom, "Force", Big.new(0.0), Big.new(1.13), Big.new(0.07), Big.new(15)), AttributAtome.new(hydrogeneAtom, "Vitesse", Big.new(0.0), Big.new(1.38), Big.new(0.15), Big.new(30))] #AttributAtome.new(newAtome, "COIIIn", 0, 20, 50, 100)
	hydrogeneAtom.DefineAtomeAttributs(hydrogenAttributsList)
	hydrogeneAtom.isUnlocked = true
	
	AtomsListInitializingGame.append(hydrogeneAtom)
	
	var heliumAtom = Atome.new("Helium", Big.new(0.25, 0))
	var heliumAttributsList = [AttributAtome.new(heliumAtom, "Spin", Big.new(1.0, 5), Big.new(1.32), Big.new(0.12), Big.new(50)), AttributAtome.new(heliumAtom, "Angle", Big.new(0.0), Big.new(1.40), Big.new(0.2), Big.new(50)), AttributAtome.new(heliumAtom, "Complexity", Big.new(0.0), Big.new(1.6), Big.new(0.5), Big.new(100))]
	heliumAtom.DefineAtomeAttributs(heliumAttributsList)
	heliumAtom.DefineAtomeUnlockingPrice({"Hydrogene" : Big.new(1.0, 2)})
	
	AtomsListInitializingGame.append(heliumAtom)


func DefineResearchListInitializingGame():
	var easyResearch = Recherche.ResearchLevelEnum.EASY
	
	listeRechercheInitializeGame.append(Recherche.new(0, "PRIXHYDROGENE1", "UPPRIXHYDROGENE1", Big.new(1.0, 3), "PrixHydrogeneAugmentation", Big.new(0.5, 0), easyResearch))
	listeRechercheInitializeGame.append(Recherche.new(1, "PRIXHYDROGENE2", "UPPRIXHYDROGENE2", Big.new(5.0, 3), "PrixHydrogeneAugmentation", Big.new(1.0, 0), easyResearch))
	listeRechercheInitializeGame.append(Recherche.new(2, "PRIXHYDROGENE3", "UPPRIXHYDROGENE3", Big.new(2.0, 4), "PrixHydrogeneAugmentation", Big.new(1.0, 1), easyResearch))
	listeRechercheInitializeGame.append(Recherche.new(3, "Test Multi", "On test le multi du rapport", Big.new(2.0, 4), "HydrogeneCoeffMultiplicateurRapport", Big.new(2.0), easyResearch))
	
	#ListeRecherches.append(Recherche.new(2, "Coin3", "Améliore 1 000%", 20000, "PrixHydrogenePerCent", 1000))
	#ListeRecherches.append(Recherche.new(3, "Coin4", "Améliore 10 000%", 50000, "PrixHydrogenePerCent", 10000))


func save():
	#Pour les quantitées
	var atomsQuantityDictionnary = {}
	for atomName in QuantiteesAtomes:
		atomsQuantityDictionnary[atomName] = QuantiteesAtomes[atomName].ToJsonFormat()
	
	#Pour les atomes
	var atomsDictionnary = {}
	for atomeName in AtomsList:
		var attributsDictionnary = {}
		for attributs in AtomsList[atomeName].ListeAttribs:
			attributsDictionnary[attributs.Name] = attributs.Niveau.ToJsonFormat()
		atomsDictionnary[atomeName] = {"Attributs" : attributsDictionnary, "Unlock" : AtomsList[atomeName].isUnlocked}
		
	#Pour les recherches
	var researchesList = []
	for research in ListeRecherches:
		researchesList.append({"Id" : research.Id, "IsUnlocked" : research.IsUnlocked})
	
	#Pour les améliorations de l'helium
	var heliumUpgradesList = []
	for upgradeHelium in ListeAmeliorationsHelium:
		heliumUpgradesList.append({"Id" : upgradeHelium.Id, "IsUnlocked" : upgradeHelium.IsUnlocked, "Level" : upgradeHelium.Level.ToJsonFormat()})
		
	var save_dict = {
		"Langue" : LangueManager.languageCourrant,
		"Coins" : Coins.ToJsonFormat(),
		"AtomsQuantity" : atomsQuantityDictionnary,
		"AtomsList" : atomsDictionnary,
		"ResearchesList" : researchesList,
		"HeliumUpgradesList" : heliumUpgradesList
	}
	
	return save_dict
