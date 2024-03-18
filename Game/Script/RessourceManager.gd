extends Node

var Coins
var QuantiteesAtomes = {}

#Liste de tous les atomes, pour avoir un accès de partout
var ListeAtomes = {}


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
	var listeAtomesInSaving
	var listeRecherchesInSaving
	var listeAmeliorationsHeliumInSaving
	
	if ressourceLoadingGame != null:
		if ressourceLoadingGame.has("Coins"):
			Coins = Big.ToCustomFormat(ressourceLoadingGame["Coins"])
		if ressourceLoadingGame.has("QuantiteesAtomes"):
			quantiteesAtomesInSaving = ressourceLoadingGame["QuantiteesAtomes"]
		if ressourceLoadingGame.has("ListeAtomes"):
			listeAtomesInSaving = ressourceLoadingGame["ListeAtomes"]
		if ressourceLoadingGame.has("ListeRecherches"):
			listeRecherchesInSaving = ressourceLoadingGame["ListeRecherches"]
		if ressourceLoadingGame.has("ListeAmeliorationsHelium"):
			listeAmeliorationsHeliumInSaving = ressourceLoadingGame["ListeAmeliorationsHelium"]
	else:
		Coins = Big.new(0, 0)

	Coins = Big.new(0, 0)
	
	#for atome in ListeAtomes:
	#	QuantiteesAtomes[atome] = CustomNumber.new()
	loadAtomes(quantiteesAtomesInSaving, listeAtomesInSaving)
	loadResearch(listeRecherchesInSaving)
	loadAmeliorationHelium(listeAmeliorationsHeliumInSaving)
	loadDarkMatter()



#Permet de charger la liste des atomes, et des quantitees possedees
func loadAtomes(quantiteesAtomesInSaving, listeAtomesInSaving):
	var listeAtomesInitializeGame = []
	#On définit les atomes auxquels on a accès :)
	var newAtome = Atome.new("Hydrogene", Big.new(1.0, 0), Big.new(1.0, 0))
	var ListeAttribsTest = [AttributAtome.new(newAtome, "Force", Big.new(0.0), Big.new(1.13), Big.new(1.07), Big.new(15)), AttributAtome.new(newAtome, "Vitesse", Big.new(0.0), Big.new(1.38), Big.new(1.15), Big.new(30))] #AttributAtome.new(newAtome, "COIIIn", 0, 20, 50, 100)
	newAtome.DefineAtomeAttributs(ListeAttribsTest)
	newAtome.isUnlocked = true
	
	listeAtomesInitializeGame.append(newAtome)
	
	var newAtome2 = Atome.new("Helium", Big.new(0.25, 0))
	var ListeAttribsTest2 = [AttributAtome.new(newAtome2, "Spin", Big.new(1.0, 5), Big.new(1.32), Big.new(1.12), Big.new(50)), AttributAtome.new(newAtome2, "Angle", Big.new(0.0), Big.new(1.40), Big.new(1.2), Big.new(50)), AttributAtome.new(newAtome2, "Complexity", Big.new(0.0), Big.new(1.6), Big.new(1.5), Big.new(100))]
	newAtome2.DefineAtomeAttributs(ListeAttribsTest2)
	newAtome2.DefineAtomeUnlockingPrice({"Hydrogene" : Big.new(1.0, 2)})
	
	listeAtomesInitializeGame.append(newAtome2)
	
	var newAtome3 = Atome.new("Fer", Big.new(0.25, 0))
	var ListeAttribsTest3 = [AttributAtome.new(newAtome3, "Tourette", Big.new(0.0), Big.new(1.0, 1), Big.new(5.0, 1), Big.new(5.0))]
	newAtome3.DefineAtomeAttributs(ListeAttribsTest3)
	newAtome3.DefineAtomeUnlockingPrice({"Helium" : Big.new(1.0, 2)})
	
	#listeAtomesInitializeGame.append(newAtome3)
	
	#Pour chaque atome dans la liste du jeu
	for atomeInitialized in listeAtomesInitializeGame:
		#Si on a recupérer une liste d'atomes dans la sauvegarde et que l'atome existe dans la sauvegarde
		if listeAtomesInSaving != null and listeAtomesInSaving[atomeInitialized.Name] != null:
			
			#Faut qu'on definniisse le niveau pour tous les attributs de l'atome
			for attributInitialized in atomeInitialized.ListeAttribs:
				#On récupère le bon attribut de l'atome dans la liste de jeu
				var attributLevelInSave = listeAtomesInSaving[atomeInitialized.Name]["Attributs"][attributInitialized.Name] 
				#Si il existe, il faut qu'on change le niveau
				if  attributLevelInSave != null:
					attributInitialized.Niveau = Big.ToCustomFormat(attributLevelInSave)
			
			#Faut qu'on définisse si l'atome est débloqué ou pas
			var isAtomeUnlockedInSave = listeAtomesInSaving[atomeInitialized.Name]["Unlock"]
			if isAtomeUnlockedInSave != null:
				if isAtomeUnlockedInSave:
					atomeInitialized.isUnlocked = true
		
		#On récupère la quantité de l'atome aussi
		if quantiteesAtomesInSaving != null and quantiteesAtomesInSaving[atomeInitialized.Name] != null:
			QuantiteesAtomes[atomeInitialized.Name] = Big.ToCustomFormat(quantiteesAtomesInSaving[atomeInitialized.Name])
		else:
			QuantiteesAtomes[atomeInitialized.Name] = Big.new(0.0)
	
	for initializedAtome in listeAtomesInitializeGame:
		ListeAtomes[initializedAtome.Name] = initializedAtome


#Permet de charger la liste des recherches
func loadResearch(listeRecherchesInSaving):
	var listeRechercheInitializeGame = []
	var easyResearch = Recherche.ResearchLevelEnum.EASY
	listeRechercheInitializeGame.append(Recherche.new(0, "Prix Hydrogène", "Augmentation du prix de l'hydrogène de 50%.", Big.new(1.0, 3), "PrixHydrogeneAugmentation", Big.new(0.5, 0), easyResearch))
	listeRechercheInitializeGame.append(Recherche.new(1, "Prix Hydrogène", "Augmentation du prix de l'hydrogène de 100%.", Big.new(5.0, 3), "PrixHydrogeneAugmentation", Big.new(1.0, 0), easyResearch))
	listeRechercheInitializeGame.append(Recherche.new(2, "Prix Hydrogène", "Augmentation du prix de l'hydrogène de 1 000%.", Big.new(2.0, 4), "PrixHydrogeneAugmentation", Big.new(1.0, 1), easyResearch))
	#ListeRecherches.append(Recherche.new(2, "Coin3", "Améliore 1 000%", 20000, "PrixHydrogenePerCent", 1000))
	#ListeRecherches.append(Recherche.new(3, "Coin4", "Améliore 10 000%", 50000, "PrixHydrogenePerCent", 10000))
	
	if not listeRecherchesInSaving == null:
		for initializedRecherche in listeRechercheInitializeGame:
			if not listeRecherchesInSaving[initializedRecherche.Id] == null:
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
	var darkMatter1 = AmeliorationDarkMatter.new(0, "Evolution Hydrogène", "Double l'apport d'hydrogène par seconde.", Big.new(1.0, 3), Big.new(0.5, 0))
	ListeAmeliorationsDarkMatter.append(darkMatter1)


func save():
	#Pour les quantitées
	var quantityDictionnary = {}
	for quantiteeName in QuantiteesAtomes:
		quantityDictionnary[quantiteeName] = QuantiteesAtomes[quantiteeName].ToJsonFormat()
	
	#Pour les atomes
	var atomesDictionnary = {}
	for atomeName in ListeAtomes:
		var attributsDictionnary = {}
		for attributs in ListeAtomes[atomeName].ListeAttribs:
			attributsDictionnary[attributs.Name] = attributs.Niveau.ToJsonFormat()
		atomesDictionnary[atomeName] = {"Attributs" : attributsDictionnary, "Unlock" : ListeAtomes[atomeName].isUnlocked}
		
	#Pour les recherches
	var rechercheListe = []
	for recherche in ListeRecherches:
		rechercheListe.append({"Id" : recherche.Id, "IsUnlocked" : recherche.IsUnlocked})
	
	#Pour les améliorations de l'helium
	var ameliorationsHeliumListe = []
	for ameliorationHelium in ListeAmeliorationsHelium:
		ameliorationsHeliumListe.append({"Id" : ameliorationHelium.Id, "IsUnlocked" : ameliorationHelium.IsUnlocked, "Level" : ameliorationHelium.Level.ToJsonFormat()})
		
	var save_dict = {
		"Coins" : Coins.ToJsonFormat(),
		"QuantiteesAtomes" : quantityDictionnary,
		"ListeAtomes" : atomesDictionnary,
		"ListeRecherches" : rechercheListe,
		"ListeAmeliorationsHelium" : ameliorationsHeliumListe
	}
	
	return save_dict
