class_name Molecule

var Id
var Name
var Description
var Prix

var AtomePriceForUnlocking = {"Beryllium" : Big.new(1.0, 2)}
var IsUnlocked = false

#Sur quoi on base la production de la molécule
var AtomeBaseConsomation

var Augmentation:Array
var AugmentationPercent

func _init(id, name, prix: Big, augmentation, augmentationPercent: Big, isUnlocked:bool = false):
	Id = id
	Name = name
	Prix = prix
	Augmentation = augmentation
	AugmentationPercent = augmentationPercent
	IsUnlocked = isUnlocked


#Permet de definir le prix pour débloquer la molécule.
func DefineUnlockingPrice(atomePriceForUnlocking):
	AtomePriceForUnlocking = atomePriceForUnlocking


#Permet de définir sur quel base on génère la molécule
func DefineAtomeBaseComation(atomeBaseConsomation):
	AtomeBaseConsomation = atomeBaseConsomation


#Permet de récupérer le dictionnaire de la consomation pour le calcul de la quantitée des molécules
func GetMoleculeProductionPerSeconde():
	var resultDictionnary = {}
	for consomation in AtomeBaseConsomation:
		var atomeQuantity = RessourceManager.QuantiteesAtomes[consomation]
		resultDictionnary[consomation] = Big.power(atomeQuantity, 1.0 / (2 * AtomeBaseConsomation[consomation]))
	return resultDictionnary
