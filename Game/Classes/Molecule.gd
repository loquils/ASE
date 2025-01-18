class_name Molecule

var Id
var Name
var Description

var AtomePriceForUnlocking = {"Beryllium" : Big.new(1.0, 2)}
var IsUnlocked = false

#Sur quoi on base la production de la molécule
var AtomeBaseConsomation

#Sur quels atomes on met un bonus en fonction de la molécule
var AtomeBaseSortie = {}

#Type de molécule celon quel endroit elle provient.
enum TypeMoleculeEnum { Base, Carbone}
var TypeMolecule:TypeMoleculeEnum

func _init(id, name, typeMolecule:TypeMoleculeEnum = TypeMoleculeEnum.Base, isUnlocked:bool = false):
	Id = id
	Name = name
	IsUnlocked = isUnlocked
	TypeMolecule = typeMolecule


#Permet de definir le prix pour débloquer la molécule.
func DefineUnlockingPrice(atomePriceForUnlocking):
	AtomePriceForUnlocking = atomePriceForUnlocking


#Permet de définir sur quel base on génère la molécule
func DefineAtomeBaseComation(atomeBaseConsomation):
	AtomeBaseConsomation = atomeBaseConsomation


#Permet de définir sur quels atomes on met les bonus.
func DefineAtomeSortieBonus(atomeBaseSortie):
	AtomeBaseSortie = atomeBaseSortie


#Permet de récupérer la liste des symbole des différents atomes de sortie d'une molécule.
func GetStringNomsSymboles():
	var listeSymboles = ""
	for atomeSortie in AtomeBaseSortie:
		if RessourceManager.ListeAtomes.has(atomeSortie):
			listeSymboles += RessourceManager.ListeAtomes[atomeSortie].Symbole + ", "
	return listeSymboles.left(listeSymboles.length() - 2) + " :"


#Permet de récupérer le dictionnaire de la consomation pour le calcul de la quantitée des molécules.
func GetMoleculeProductionPerSeconde():
	var calculDictionnary = {}
	var quantiteeAtomesInCreation = 0
	for consomation in AtomeBaseConsomation:
		var maxAtomeQuantity = InfosPartie.AtomesObtenusInThisReset[consomation]
		calculDictionnary[consomation] = Big.power(maxAtomeQuantity, 1.0 / (1.5 * AtomeBaseConsomation[consomation]))
		quantiteeAtomesInCreation += AtomeBaseConsomation[consomation]
	
	var partialProduction = Big.new(1.0)
	for atomConsomation in calculDictionnary:
		partialProduction = Big.multiply(partialProduction, calculDictionnary[atomConsomation])
	
	var totalProduction = Big.power(partialProduction, 1.0 / quantiteeAtomesInCreation)
	if TypeMolecule == TypeMoleculeEnum.Carbone:
		var ameliorationCarboneTrouveeDansListe = RessourceManager.ListeAmeliorationsCarbone.filter(func(ameliorationCarbone): return ameliorationCarbone.MoleculeUpgrade.Name == Name)
		if ameliorationCarboneTrouveeDansListe.size() == 1:
			if ameliorationCarboneTrouveeDansListe[0].EtatMolecule == 0:
				totalProduction = Big.divide(totalProduction, 20)
			if ameliorationCarboneTrouveeDansListe[0].EtatMolecule == 1:
				totalProduction = Big.divide(totalProduction, 10)
			if ameliorationCarboneTrouveeDansListe[0].EtatMolecule == 2:
				totalProduction = Big.divide(totalProduction, 5)
	return totalProduction


#Permet de récupérer le bonus total d'une molécule en fonction de sa quantité.
func GetMoleculeBonus(atomeName):
	if AtomeBaseSortie.has(atomeName):
		return Big.multiply(AtomeBaseSortie[atomeName], RessourceManager.QuantiteesMolecules[Name])
	
	return Big.new(0)
