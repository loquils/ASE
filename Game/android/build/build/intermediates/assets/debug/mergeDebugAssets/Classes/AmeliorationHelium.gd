class_name AmeliorationHelium

var Id
var Name
var Description

var AtomePriceForUnlocking = {"Coins" : CustomNumber.new(1.0, 2)}
var IsUnlocked = false

var Level

var PrixBase = CustomNumber.new(1.0,3)
var ApportBase

enum TypeAmeliorationHeliumEnum {Pression, Temperature} #Pression on / les prix, Temperature on augmente les rendements (genre les coefs)
var TypeAmeliorationHelium

#enum BonusTypesAmeliorationHeliumEnum { HydrogeneRendementMultiply  } #Il faut qu'on change ça en liste ... (ou dictionnaire à voir)
var BonusTypeAmeliorationHelium
var BonusAmeliorationHelium

#func _init(id, name, description, prix:CustomNumber, augmentation, augmentationPercent, researchLevel):
func _init(id, name, description, typeAmeliorationHelium:TypeAmeliorationHeliumEnum, bonusTypeAmeliorationHelium,bonusAmeliorationHelium:CustomNumber, level:CustomNumber = CustomNumber.new()):
	Id = id
	Name = name
	Description = description
	Level = level
	TypeAmeliorationHelium = typeAmeliorationHelium
	BonusTypeAmeliorationHelium = bonusTypeAmeliorationHelium
	BonusAmeliorationHelium = bonusAmeliorationHelium


#Permet de definir le prix pour débloquer un atome.
func DefineAtomeUnlockingPrice(atomePriceForUnlocking):
	AtomePriceForUnlocking = atomePriceForUnlocking


#Récupère le prix d'une amélioration, pour l'instant c'est x10 puissance niveau
func GetPrixAmeliorationHelium():
	return PrixBase.multiply(CustomNumber.new(1.0, 1).power(Level))
