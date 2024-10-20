class_name AmeliorationHelium

var Id
var Name
var Description

var AtomePriceForUnlocking = {"Coins" : Big.new(1.0, 2)}

var IsUnlocked = false
var IsBasedUnlocked = false

var Level: Big

var PrixBase = Big.new(1.0, 3)

var CoefficientAchat: Big

enum TypeAmeliorationHeliumEnum {Pression, Temperature} #Pression on / les prix, Temperature on augmente les rendements (genre les coefs)
var TypeAmeliorationHelium

#enum BonusTypesAmeliorationHeliumEnum { HydrogeneRendementMultiply  } #Il faut qu'on change ça en liste ... (ou dictionnaire à voir)
var BonusTypeAmeliorationHelium
var BonusAmeliorationHelium

#func _init(id, name, description, prix:CustomNumber, augmentation, augmentationPercent, researchLevel):
func _init(id, name, description, prixBase:Big, coefficientAchat, typeAmeliorationHelium:TypeAmeliorationHeliumEnum, bonusTypeAmeliorationHelium,bonusAmeliorationHelium:Big, isBasedUnlocked = false, level:Big = Big.new(0.0)):
	Id = id
	Name = name
	Description = description
	PrixBase = prixBase
	CoefficientAchat = coefficientAchat
	Level = level
	TypeAmeliorationHelium = typeAmeliorationHelium
	BonusTypeAmeliorationHelium = bonusTypeAmeliorationHelium
	BonusAmeliorationHelium = bonusAmeliorationHelium
	IsBasedUnlocked = isBasedUnlocked
	if not IsUnlocked and IsBasedUnlocked:
		IsUnlocked = true


#Permet de definir le prix pour débloquer un atome.
func DefineAtomeUnlockingPrice(atomePriceForUnlocking):
	AtomePriceForUnlocking = atomePriceForUnlocking


#Récupère le prix d'une amélioration, pour l'instant c'est x10 puissance niveau
func GetPrixAmeliorationHelium():
	var basePrix = Big.multiply(PrixBase, Big.power(CoefficientAchat, Level))
	var dividePrixBonuses = BonusManager.GetRecherchesAmeliorationHeCostsDivided(Id);
	return Big.divide(basePrix, dividePrixBonuses)
