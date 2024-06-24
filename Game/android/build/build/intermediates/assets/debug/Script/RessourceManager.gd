extends Node

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

#Liste des recherches en initialisation
var ListeAmeliorationsHeliumInitializeGame = []
#Liste de toutes les améliorations de l'helium 
var ListeAmeliorationsHelium = []

#Liste des recherches de matière noire en initialisation
var ListeRecherchesMatiereNoireInitializeGame = []
#Liste de toutes les améliorations de la dark matter
var ListeRecherchesMatiereNoire = []
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
		if ressourceLoadingGame.has("DarkMatter"):
			DarkMatter = Big.ToCustomFormat(ressourceLoadingGame["DarkMatter"])
		if ressourceLoadingGame.has("RecherchesMatiereNoire"):
			listeRecherchesMatiereNoireInSaving = ressourceLoadingGame["RecherchesMatiereNoire"]
	
	AtomsLoading(quantiteesAtomesInSaving, atomsListInSaving)
	LoadResearch(listeRecherchesInSaving)
	LoadAmeliorationHelium(listeAmeliorationsHeliumInSaving)
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
			if initializedRecherche.Id < len(listeRecherchesInSaving) and not listeRecherchesInSaving[initializedRecherche.Id] == null:
				if listeRecherchesInSaving[initializedRecherche.Id]["IsUnlocked"]:
					initializedRecherche.IsUnlocked = true
			
	for recherche in ListeRechercheInitializeGame:
		ListeRecherches.append(recherche)


#Permet de charger la liste des recherches
func LoadAmeliorationHelium(listeAmeliorationsHeliumInSaving):
	DefineAmeliorationHeliumListInitializingGame()
	
	if not listeAmeliorationsHeliumInSaving == null:
		for initializedAmeliorationHelium in ListeAmeliorationsHeliumInitializeGame:
			if not listeAmeliorationsHeliumInSaving[initializedAmeliorationHelium.Id] == null:
				if listeAmeliorationsHeliumInSaving[initializedAmeliorationHelium.Id]["IsUnlocked"]:
					initializedAmeliorationHelium.IsUnlocked = true
					initializedAmeliorationHelium.Level = Big.ToCustomFormat(listeAmeliorationsHeliumInSaving[initializedAmeliorationHelium.Id]["Level"])
	
	for ameliorationHelium in ListeAmeliorationsHeliumInitializeGame:
		ListeAmeliorationsHelium.append(ameliorationHelium)

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


#Calcul et ajoute la quantité d'atome à la quantité d'atome
func CalculateQuantityAtomes(timeInSeconde:int = 1):
	for atome in ListeAtomes:
		if ListeAtomes[atome].isUnlocked:
				QuantiteesAtomes[atome] = Big.multiply(Big.add(QuantiteesAtomes[atome], ListeAtomes[atome].GetAtomePerSec()), Big.new(timeInSeconde))


#---------------------------------Define all elements of the game !----------------------------------#

#Permet d'initialiser la liste des atomes dans le jeu
func DefineAtomsListInitializingGame():
	#On définit les atomes auxquels on a accès :)
	var hydrogeneAtom = Atome.new("Hydrogene", Big.new(1.0, 0), Big.new(1.0, 0))
	var hydrogenAttributsList = [AttributAtome.new(hydrogeneAtom, "Force", Big.new(1.0, 10), Big.new(1.13), Big.new(0.07), Big.new(15)), AttributAtome.new(hydrogeneAtom, "Vitesse", Big.new(0.0), Big.new(1.38), Big.new(0.15), Big.new(30))] #AttributAtome.new(newAtome, "COIIIn", 0, 20, 50, 100)
	hydrogeneAtom.DefineAtomeAttributs(hydrogenAttributsList)
	hydrogeneAtom.isUnlocked = true
	
	AtomsListInitializingGame.append(hydrogeneAtom)
	
	var heliumAtom = Atome.new("Helium", Big.new(0.25, 0))
	var heliumAttributsList = [AttributAtome.new(heliumAtom, "Spin", Big.new(1.0, 5), Big.new(1.32), Big.new(0.12), Big.new(50)), AttributAtome.new(heliumAtom, "Angle", Big.new(0.0), Big.new(1.40), Big.new(0.2), Big.new(50)), AttributAtome.new(heliumAtom, "Complexity", Big.new(0.0), Big.new(1.6), Big.new(0.5), Big.new(100))]
	heliumAtom.DefineAtomeAttributs(heliumAttributsList)
	heliumAtom.DefineAtomeUnlockingPrice({"Hydrogene" : Big.new(1.0, 2)})
	
	AtomsListInitializingGame.append(heliumAtom)

#Permet d'initialiser la liste des recherches dans le jeu
func DefineResearchListInitializingGame():
	var easyResearch = Recherche.ResearchLevelEnum.EASY
	
	ListeRechercheInitializeGame.append(Recherche.new(0, "RECHERCHE1", "RECHERCHEDESCRIPTION1", Big.new(1.0, 3), "PrixHydrogeneAugmentation", Big.new(0.5, 0), easyResearch))
	ListeRechercheInitializeGame.append(Recherche.new(1, "RECHERCHE2", "RECHERCHEDESCRIPTION2", Big.new(5.0, 3), "PrixHydrogeneAugmentation", Big.new(1.0, 0), easyResearch))
	ListeRechercheInitializeGame.append(Recherche.new(2, "RECHERCHE3", "RECHERCHEDESCRIPTION3", Big.new(2.0, 4), "HydrogeneCoeffMultiplicateurRapport", Big.new(2.0), easyResearch))
	ListeRechercheInitializeGame.append(Recherche.new(3, "RECHERCHE4", "RECHERCHEDESCRIPTION4", Big.new(7.5, 4), "PrixHydrogeneAugmentation", Big.new(5.0), easyResearch))
	ListeRechercheInitializeGame.append(Recherche.new(4, "RECHERCHE5", "RECHERCHEDESCRIPTION5", Big.new(5.0, 5), "HeliumCoeffMultiplicateurRapport", Big.new(2.0), easyResearch))


#Permet d'initialiser la liste des amélioration de l'hélium dans le jeu
func DefineAmeliorationHeliumListInitializingGame():
	var ameliorationHelium1 = AmeliorationHelium.new(0, "AMELIORATIONHELIUMPRESSION1", "AMELIORATIONHELIUMPRESSIONDESCRIPTION1", AmeliorationHelium.TypeAmeliorationHeliumEnum.Pression, "HydrogeneRendementMultiply", Big.new(2.0, 0))
	ameliorationHelium1.DefineAtomeUnlockingPrice( {"Coins" : Big.new(5.0, 3)})
	ListeAmeliorationsHeliumInitializeGame.append(ameliorationHelium1)
	
	var amelio2 = AmeliorationHelium.new(1, "AMELIORATIONHELIUMTEMPERATURE1", "AMELIORATIONHELIUMTEMPERATUREDESCRIPTION1", AmeliorationHelium.TypeAmeliorationHeliumEnum.Temperature, "HydrogeneAttributsCoefficientAdd", Big.new(0.01, 0))
	amelio2.DefineAtomeUnlockingPrice( {"Hydrogene" : Big.new(2.5, 2)})
	ListeAmeliorationsHeliumInitializeGame.append(amelio2)


#Permet d'initialiser la liste des recherches de matière noire dans le jeu
func DefineRechercheMatiereNoireListInitializingGame():
		ListeRecherchesMatiereNoireInitializeGame.append(RechercheDarkMatter.new(0, "RECHERCHEMATIERENOIRE1", "RECHERCHEMATIERENOIRE1DESCRIPTION", Big.new(20.0, 0), "HydrogeneCoeffMultiplicateurRapport", Big.new(2.0, 0)))


#------------------------------------------------------------------------------------------------------#

#Permet de remettre les atomes à zero
func ResetAtomes():
	for atome in ListeAtomes:
		for attribut in ListeAtomes[atome].ListeAttribs:
			attribut.Niveau = Big.new(0.0)
	
		if not atome == "Hydrogene":
			ListeAtomes[atome].isUnlocked = false


#Permet de remettre la quantitée des atomes à zero
func ResetRessources():
	Coins = Big.new(0.0)
	for atomeNom in ListeAtomes:
		QuantiteesAtomes[atomeNom] = Big.new(0.0)


#Permet de remettre les recherches à zeros
func ResetRecherches():
	for recherche in ListeRecherches:
		recherche.IsUnlocked = false
	BonusManager.MajBonusRecherches()


#Permet de remettre les améliorations Helium à zeros
func ResetAmeliorationsHelium():
	for ameliorationHelium in ListeAmeliorationsHelium:
		ameliorationHelium.Level = Big.new(0.0)
		ameliorationHelium.IsUnlocked = false
	BonusManager.MajBonusAmeliorationHelium()



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
		"DarkMatter" : DarkMatter.ToJsonFormat(),
		"RecherchesMatiereNoire" : recherchesMatiereNoireListe
	}
	
	return save_dict
