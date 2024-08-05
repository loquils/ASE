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

# Called when the n*ode enters the scene tree for the first time.
func _ready():
	#Il faut load la sauvegarde si elle existe :)
	var ressourceLoadingGame = Save.load_game()
	
	var quantiteesAtomesInSaving
	var atomsListInSaving
	var listeRecherchesInSaving
	var listeAmeliorationsHeliumInSaving
	var listeAmeliorationsLithiumInSaving
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
func LoadResearchOld(listeRecherchesInSaving):
	#On définit la liste de base des recherches
	DefineResearchListInitializingGame()
	
	if not listeRecherchesInSaving == null:
		for initializedRecherche in ListeRechercheInitializeGame:
			if initializedRecherche.Id < len(listeRecherchesInSaving) and not listeRecherchesInSaving[initializedRecherche.Id] == null:
				if listeRecherchesInSaving[initializedRecherche.Id]["IsUnlocked"]:
					initializedRecherche.IsUnlocked = true
			
	for recherche in ListeRechercheInitializeGame:
		ListeRecherches.append(recherche)
	
	BonusManager.MajBonusRecherches()


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
	
	BonusManager.MajBonusRecherches()

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
	
	BonusManager.MajBonusRecherchesMatiereNoire()


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
	var attribut1Hydrogene = AttributAtome.new(hydrogeneAtom, "Force", Big.new(0.0), Big.new(1.11), Big.new(0.12), Big.new(5))
	var attribut2Hydrogene = AttributAtome.new(hydrogeneAtom, "Vitesse", Big.new(0.0), Big.new(1.34), Big.new(0.25), Big.new(10))
	var hydrogenAttributsList = [attribut1Hydrogene, attribut2Hydrogene]
	hydrogeneAtom.DefineAtomeAttributs(hydrogenAttributsList)
	hydrogeneAtom.isUnlocked = true
	
	AtomsListInitializingGame.append(hydrogeneAtom)
	
	var heliumAtom = Atome.new("Helium", Big.new(0.7, 0))
	var attribut1Helium = AttributAtome.new(heliumAtom, "Force", Big.new(0.0), Big.new(1.30), Big.new(0.10), Big.new(50))
	var attribut2Helium = AttributAtome.new(heliumAtom, "Rotation", Big.new(0.0), Big.new(1.36), Big.new(0.2), Big.new(75))
	var attribut3Helium = AttributAtome.new(heliumAtom, "Complexitee", Big.new(0.0), Big.new(1.82), Big.new(0.42), Big.new(120))
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
	lithiumAtom.DefineAtomeUnlockingPrice({"Helium" : Big.new(2.0, 5)})
	
	AtomsListInitializingGame.append(lithiumAtom)


#Permet d'initialiser la liste des recherches dans le jeu
func DefineResearchListInitializingGame():
	var debutRecherche = Recherche.ResearchLevelEnum.DEBUT
	var easyRecherche = Recherche.ResearchLevelEnum.EASY
	
	ListeRechercheInitializeGame.append(Recherche.new(0, "RECHERCHE1", "RECHERCHEDESCRIPTION1", Big.new(2.5, 2), "PrixHydrogeneAugmentation", Big.new(0.25, 0), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(1, "RECHERCHE2", "RECHERCHEDESCRIPTION2", Big.new(5.0, 2), "PrixHydrogeneAugmentation", Big.new(0.5, 0), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(8, "RECHERCHE9", "RECHERCHEDESCRIPTION9", Big.new(1.0, 3), "HydrogeneCoeffMultiplicateurRapportParRecherche", Big.new(0.25), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(2, "RECHERCHE3", "RECHERCHEDESCRIPTION3", Big.new(2.0, 3), "PrixHydrogeneAugmentation", Big.new(1.0, 0), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(3, "RECHERCHE4", "RECHERCHEDESCRIPTION4", Big.new(6.0, 3), "HydrogeneAttributsCostDivided", Big.new(3.0), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(7, "RECHERCHE8", "RECHERCHEDESCRIPTION8", Big.new(2.0, 4), "AllCoeffMultiplicateurRapportParRecherche", Big.new(0.08), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(4, "RECHERCHE5", "RECHERCHEDESCRIPTION5", Big.new(5.0, 4), "HydrogeneCoeffMultiplicateurRapport", Big.new(2.0), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(5, "RECHERCHE6", "RECHERCHEDESCRIPTION6", Big.new(2.0, 5), "PrixHydrogeneAugmentation", Big.new(5.0), debutRecherche))
	ListeRechercheInitializeGame.append(Recherche.new(6, "RECHERCHE7", "RECHERCHEDESCRIPTION7", Big.new(8.5, 5), "HeliumCoeffMultiplicateurRapport", Big.new(2.0), debutRecherche))


#Permet d'initialiser la liste des amélioration de l'hélium dans le jeu
func DefineAmeliorationHeliumListInitializingGame():
	var ameliorationHeliumPression1 = AmeliorationHelium.new(0, "AMELIORATIONHELIUMPRESSION1", "AMELIORATIONHELIUMPRESSIONDESCRIPTION1", Big.new(1.0, 2), Big.new(2.5), AmeliorationHelium.TypeAmeliorationHeliumEnum.Pression, "HydrogeneOutputMultiply", Big.new(0.05))
	ameliorationHeliumPression1.DefineAtomeUnlockingPrice( {"Helium" : Big.new(0.0)})
	ameliorationHeliumPression1.IsUnlocked = true
	ListeAmeliorationsHeliumInitializeGame.append(ameliorationHeliumPression1)
	
	var ameliorationHeliumPression2 = AmeliorationHelium.new(1, "AMELIORATIONHELIUMPRESSION2", "AMELIORATIONHELIUMPRESSIONDESCRIPTION2", Big.new(1.0, 3), Big.new(1.0, 1), AmeliorationHelium.TypeAmeliorationHeliumEnum.Pression, "PressionEfficacitee0", Big.new(0.1))
	ameliorationHeliumPression2.DefineAtomeUnlockingPrice( {"Helium" : Big.new(5.0, 3)})
	ListeAmeliorationsHeliumInitializeGame.append(ameliorationHeliumPression2)
	
	var ameliorationHeliumPression3 = AmeliorationHelium.new(2, "AMELIORATIONHELIUMPRESSION3", "AMELIORATIONHELIUMPRESSIONDESCRIPTION3", Big.new(2.0, 5), Big.new(2.5, 1), AmeliorationHelium.TypeAmeliorationHeliumEnum.Pression, "PressionEfficacitee1", Big.new(0.25))
	ameliorationHeliumPression3.DefineAtomeUnlockingPrice( {"Helium" : Big.new(1.0, 6)})
	ListeAmeliorationsHeliumInitializeGame.append(ameliorationHeliumPression3)
	
	
	var ameliorationHeliumTemperature1 = AmeliorationHelium.new(3, "AMELIORATIONHELIUMTEMPERATURE1", "AMELIORATIONHELIUMTEMPERATUREDESCRIPTION1", Big.new(5.0, 2), Big.new(2.5), AmeliorationHelium.TypeAmeliorationHeliumEnum.Temperature, "HydrogeneAttributsCoefficientAdd", Big.new(0.01))
	ameliorationHeliumTemperature1.DefineAtomeUnlockingPrice( {"Helium" : Big.new(1.0, 3)})
	ListeAmeliorationsHeliumInitializeGame.append(ameliorationHeliumTemperature1)
	
	var ameliorationHeliumTemperature2 = AmeliorationHelium.new(4, "AMELIORATIONHELIUMTEMPERATURE2", "AMELIORATIONHELIUMTEMPERATUREDESCRIPTION2", Big.new(1.0, 4), Big.new(1.0, 1), AmeliorationHelium.TypeAmeliorationHeliumEnum.Temperature, "TemperatureEfficacitee0", Big.new(0.04))
	ameliorationHeliumTemperature2.DefineAtomeUnlockingPrice( {"Helium" : Big.new(2.5, 4)})
	ListeAmeliorationsHeliumInitializeGame.append(ameliorationHeliumTemperature2)
	
	var ameliorationHeliumTemperature3 = AmeliorationHelium.new(5, "AMELIORATIONHELIUMTEMPERATURE3", "AMELIORATIONHELIUMTEMPERATUREDESCRIPTION3", Big.new(2.5, 6), Big.new(2.5, 1), AmeliorationHelium.TypeAmeliorationHeliumEnum.Temperature, "TemperatureEfficacitee1", Big.new(0.12))
	ameliorationHeliumTemperature3.DefineAtomeUnlockingPrice( {"Helium" : Big.new(8.0, 6)})
	ListeAmeliorationsHeliumInitializeGame.append(ameliorationHeliumTemperature3)


#Permet d'initialiser la liste des amélioration du lithium dans le jeu
func DefineAmeliorationLithiumListInitializingGame():
	var ameliorationLithiumProton = AmeliorationLithium.new(0, "Proton", "AMELIORATIONLITHIUMPROTONDESCRIPTION", Big.new(1.0, 2), Big.new(2.5), AmeliorationLithium.CategorieAmeliorationLithiumEnum.Proton, "HeliumOutputMultiply", Big.new(0.05))
	ameliorationLithiumProton.DefineUnlockingPrice( {"Lithium" : Big.new(1.0, 0)})
	ameliorationLithiumProton.IsUnlocked = true
	ListeAmeliorationsLithiumInitializeGame.append(ameliorationLithiumProton)
	
	var ameliorationLithiumNeutron = AmeliorationLithium.new(1, "Neutron", "AMELIORATIONLITHIUMNEUTRONDESCRIPTION", Big.new(5.0, 2), Big.new(2.5), AmeliorationLithium.CategorieAmeliorationLithiumEnum.Neutron, "HeliumAttributsCostDivided", Big.new(0.1))
	ameliorationLithiumNeutron.DefineUnlockingPrice( {"Lithium" : Big.new(1.0, 3)})
	ListeAmeliorationsLithiumInitializeGame.append(ameliorationLithiumNeutron)
	
	var ameliorationLithiumElectronK1 = AmeliorationLithium.new(2, "ElectronK1", "AMELIORATIONLITHIUMELECTRONK1DESCRIPTION", Big.new(1.0, 4), Big.new(1.0, 1), AmeliorationLithium.CategorieAmeliorationLithiumEnum.ElectronK, "ProtonEfficacitee", Big.new(0.05))
	ameliorationLithiumElectronK1.DefineUnlockingPrice( {"Lithium" : Big.new(3.0, 3)})
	ListeAmeliorationsLithiumInitializeGame.append(ameliorationLithiumElectronK1)
	
	var ameliorationLithiumElectronK2 = AmeliorationLithium.new(3, "ElectronK2", "AMELIORATIONLITHIUMELECTRONK2DESCRIPTION", Big.new(5.0, 4), Big.new(1.0, 1), AmeliorationLithium.CategorieAmeliorationLithiumEnum.ElectronK, "NeutronEfficacitee", Big.new(0.2))
	ameliorationLithiumElectronK2.DefineUnlockingPrice( {"Lithium" : Big.new(5.0, 5)})
	ListeAmeliorationsLithiumInitializeGame.append(ameliorationLithiumElectronK2)
	
	var ameliorationLithiumElectronL1 = AmeliorationLithium.new(4, "ElectronL1", "AMELIORATIONLITHIUMELECTRONLDESCRIPTION", Big.new(1.0, 7), Big.new(2.5, 1), AmeliorationLithium.CategorieAmeliorationLithiumEnum.ElectronL, "ElectronsKEfficacitee", Big.new(0.25))
	ameliorationLithiumElectronL1.DefineUnlockingPrice( {"Lithium" : Big.new(5.0, 6)})
	ListeAmeliorationsLithiumInitializeGame.append(ameliorationLithiumElectronL1)

#Permet d'initialiser la liste des recherches de matière noire dans le jeu
func DefineRechercheMatiereNoireListInitializingGame():
		ListeRecherchesMatiereNoireInitializeGame.append(RechercheDarkMatter.new(0, "RECHERCHEMATIERENOIRE1", "RECHERCHEMATIERENOIRE1DESCRIPTION", Big.new(1.0, 0), "HydrogeneOutputMultiplyParRechercheMN", Big.new(1.0, 0)))
		ListeRecherchesMatiereNoireInitializeGame.append(RechercheDarkMatter.new(1, "RECHERCHEMATIERENOIRE2", "RECHERCHEMATIERENOIRE2DESCRIPTION", Big.new(1.0, 1), "HydrogeneAttributsCostDividedParRechercheMN", Big.new(5.0, 0)))
		ListeRecherchesMatiereNoireInitializeGame.append(RechercheDarkMatter.new(2, "RECHERCHEMATIERENOIRE3", "RECHERCHEMATIERENOIRE3DESCRIPTION", Big.new(1.0, 2), "HeliumOutputMultiply", Big.new(1.0, 0)))
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


#Permet de remettre les améliorations Lithium à zeros
func ResetAmeliorationsLithium():
	for ameliorationLithium in ListeAmeliorationsLithium:
		ameliorationLithium.Level = Big.new(0.0)
		ameliorationLithium.IsUnlocked = false
	BonusManager.MajBonusAmeliorationLithium()


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

	#Pour les recherches de matière noire
	var recherchesMatiereNoireListe = []
	for rechercheMatiereNoire in ListeRecherchesMatiereNoire:
		recherchesMatiereNoireListe.append({"Id" : rechercheMatiereNoire.Id, "IsUnlocked" : rechercheMatiereNoire.IsUnlocked})

	var dictSavePartie = InfosPartie.Save()
	
	var save_dict = {
		"Langue" : LangueManager.languageCourrant,
		"Coins" : Coins.ToJsonFormat(),
		"AtomsQuantity" : atomsQuantityDictionnary,
		"ListeAtomes" : atomsDictionnary,
		"ResearchesList" : recherchesListe,
		"HeliumUpgradesList" : ameliorationHeliumList,
		"LithiumUpgradesList" : ameliorationLithiumList,
		"DarkMatter" : DarkMatter.ToJsonFormat(),
		"RecherchesMatiereNoire" : recherchesMatiereNoireListe,
		"InformationsPartie" : InfosPartie.Save(),
		"TutorialCompleted" : IsTutorialCompleted
	}
	
	return save_dict
