class_name Molecule

var Id
var Name
var Description

var AtomePriceForUnlocking = {"Beryllium" : Big.new(1.0, 2)}
var IsUnlocked = false

#Sur quoi on base la production de la molécule
var AtomeBaseConsomation

#Sur quels atomes on met un bonus en fonction de la molécule
var AtomeBaseSortie

func _init(id, name, isUnlocked:bool = false):
	Id = id
	Name = name
	IsUnlocked = isUnlocked


#Permet de definir le prix pour débloquer la molécule.
func DefineUnlockingPrice(atomePriceForUnlocking):
	AtomePriceForUnlocking = atomePriceForUnlocking


#Permet de définir sur quel base on génère la molécule
func DefineAtomeBaseComation(atomeBaseConsomation):
	AtomeBaseConsomation = atomeBaseConsomation


#Permet de définir sur quels atomes on met les bonus.
func DefineAtomeSortieBonus(atomeBaseSortie):
	AtomeBaseSortie = atomeBaseSortie


#Permet de récupérer le dictionnaire de la consomation pour le calcul de la quantitée des molécules
func GetMoleculeProductionPerSeconde():
	var calculDictionnary = {}
	var quantiteeAtomesInCreation = 0
	for consomation in AtomeBaseConsomation:
		var maxAtomeQuantity = InfosPartie.AtomesObtenuInThisReset[consomation]
		calculDictionnary[consomation] = Big.power(maxAtomeQuantity, 1.0 / (1.5 * AtomeBaseConsomation[consomation]))
		quantiteeAtomesInCreation += AtomeBaseConsomation[consomation]
	
	var partialProduction = Big.new(1.0)
	for atomConsomation in calculDictionnary:
		partialProduction = Big.multiply(partialProduction, calculDictionnary[atomConsomation])
	
	var totalProduction = Big.power(partialProduction, 1.0 / quantiteeAtomesInCreation)
	return totalProduction
