class_name AmeliorationLithium

var Id
var Name
var Description

var AtomePriceForUnlocking = {"Lithium" : Big.new(1.0, 2)}
var IsUnlocked = false
var IsBasedUnlocked = false

var Level: Big

var PrixBase = Big.new(1.0, 0)

var CoefficientAchat: Big

enum CategorieAmeliorationLithiumEnum {Proton, Neutron, ElectronK, ElectronL}
var CategorieAmeliorationLithium

var BonusTypeAmeliorationLithium
var BonusAmeliorationLithium

func _init(id, name, description, prixBase:Big, coefficientAchat, categorieAmeliorationLithium:CategorieAmeliorationLithiumEnum, bonusTypeAmeliorationLithium,bonusAmeliorationLithium:Big,isBasedUnlocked = false, level:Big = Big.new(0.0)):
	Id = id
	Name = name
	Description = description
	PrixBase = prixBase
	CoefficientAchat = coefficientAchat
	Level = level
	CategorieAmeliorationLithium = categorieAmeliorationLithium
	BonusTypeAmeliorationLithium = bonusTypeAmeliorationLithium
	BonusAmeliorationLithium = bonusAmeliorationLithium
	IsBasedUnlocked = isBasedUnlocked
	if not IsUnlocked and IsBasedUnlocked:
		IsUnlocked = true


#Permet de definir le prix pour débloquer l'amélioration.
func DefineUnlockingPrice(atomePriceForUnlocking):
	AtomePriceForUnlocking = atomePriceForUnlocking


func GetPrixAmeliorationLithium():
	return Big.multiply(PrixBase, Big.power(CoefficientAchat, Level))


#func GetBonusAmeliorationLithium():
#	match CategorieAmeliorationLithium:
#		CategorieAmeliorationLithiumEnum.Proton:
#			var currentBonusFromAmelioration = Big.add(BonusAmeliorationLithium, Big.mutiply(BonusAmeliorationLithium, BonusManager.CurrentBonusesAmeliorationLithium["ProtonEfficaciteePourcent"])
#			var bonusAmeliorationAvecBonus = Big.multiply(currentBonusFromAmelioration, Level)
#			return bonusAmeliorationAvecBonus
