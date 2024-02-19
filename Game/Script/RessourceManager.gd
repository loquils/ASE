extends Node

var Coins
var QuantiteesAtomes = {}

#Liste de tous les atomes, pour avoir un accès de partout
var ListeAtomes = {}

# Called when the n*ode enters the scene tree for the first time.
func _ready():
	#Il faut load la sauvegarde si elle existe :)
	var ressourceLoadingGame = Save.load_game()
	
	var quantiteesAtomesInSaving
	var listeAtomesInSaving
	
	if ressourceLoadingGame != null:
		Coins = CustomNumber.ToCustomFormat(ressourceLoadingGame["Coins"])
		quantiteesAtomesInSaving = ressourceLoadingGame["QuantiteesAtomes"]
		listeAtomesInSaving = ressourceLoadingGame["ListeAtomes"]
	else:
		Coins = CustomNumber.new(0, 0)
	
	
	var listeAtomesInitializeGame = []
	#On définit les atomes auxquels on a accès :)
	var newAtome = Atome.new("Hydrogene", CustomNumber.new(1.0, 0), CustomNumber.new(1.0, 0))
	var ListeAttribsTest = [AttributAtome.new(newAtome, "Force", CustomNumber.new(), CustomNumber.new(1.15), CustomNumber.new(1.07), CustomNumber.new(10)), AttributAtome.new(newAtome, "Vitesse", CustomNumber.new(), CustomNumber.new(1.40), CustomNumber.new(1.15), CustomNumber.new(15))] #AttributAtome.new(newAtome, "COIIIn", 0, 20, 50, 100)
	newAtome.DefineAtomeAttributs(ListeAttribsTest)
	newAtome.isUnlocked = true
	
	listeAtomesInitializeGame.append(newAtome)
	
	var newAtome2 = Atome.new("Helium", CustomNumber.new(0.25, 0))
	var ListeAttribsTest2 = [AttributAtome.new(newAtome2, "Spin", CustomNumber.new(), CustomNumber.new(1.32), CustomNumber.new(1.12), CustomNumber.new(50)), AttributAtome.new(newAtome2, "Angle", CustomNumber.new(), CustomNumber.new(1.40), CustomNumber.new(1.2), CustomNumber.new(50)), AttributAtome.new(newAtome2, "Complexity", CustomNumber.new(), CustomNumber.new(1.6), CustomNumber.new(1.5), CustomNumber.new(100))]
	newAtome2.DefineAtomeAttributs(ListeAttribsTest2)
	newAtome2.DefineAtomeUnlockingPrice({"Hydrogene" : CustomNumber.new(1.0, 2)})
	
	listeAtomesInitializeGame.append(newAtome2)
	
	#var newAtome3 = Atome.new("Fer", 0.3)
	#var ListeAttribsTest3 = [AttributAtome.new(newAtome3, "Tourette", 0, 10, 50, 5)]
	#newAtome3.DefineAtomeAttributs(ListeAttribsTest3)
	#newAtome3.DefineAtomeUnlockingPrice({"Helium" : 100})
	
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
					attributInitialized.Niveau = CustomNumber.ToCustomFormat(attributLevelInSave)
			
			#Faut qu'on définisse si l'atome est débloqué ou pas
			var isAtomeUnlockedInSave = listeAtomesInSaving[atomeInitialized.Name]["Unlock"]
			if isAtomeUnlockedInSave != null:
				if isAtomeUnlockedInSave:
					atomeInitialized.isUnlocked = true
		
		#On récupère la quantité de l'atome aussi
		if quantiteesAtomesInSaving != null and quantiteesAtomesInSaving[atomeInitialized.Name] != null:
			QuantiteesAtomes[atomeInitialized.Name] = CustomNumber.ToCustomFormat(quantiteesAtomesInSaving[atomeInitialized.Name])
	
	for initializedAtome in listeAtomesInitializeGame:
		print(initializedAtome.Name)
		ListeAtomes[initializedAtome.Name] = initializedAtome
	
	#for atome in ListeAtomes:
	#	QuantiteesAtomes[atome] = CustomNumber.new()


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
		
		
	var save_dict = {
		"Coins" : Coins.ToJsonFormat(),
		"QuantiteesAtomes" : quantityDictionnary,
		"ListeAtomes" : atomesDictionnary
	}
	
	return save_dict
