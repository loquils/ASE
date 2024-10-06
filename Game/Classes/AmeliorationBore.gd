class_name AmeliorationBore

var Id
var Name
var Description

var AtomePriceForUnlocking = {"Bore" : Big.new(1.0, 2)}
var IsUnlocked = false
var IsBasedUnlocked = false

var Level: Big

var PrixBase = Big.new(1.0, 3)

var CoefficientAchat: Big

enum TypeAmeliorationBoreEnum {Classic, Advanced}
var TypeAmeliorationBore

var BonusTypeAmeliorationBore
var BonusAmeliorationBore

func _init(id, name, description, prixBase:Big, coefficientAchat, typeAmeliorationBore:TypeAmeliorationBoreEnum, bonusTypeAmeliorationBore, bonusAmeliorationBore:Big, isBasedUnlocked = false, level:Big = Big.new(0.0)):
	Id = id
	Name = name
	Description = description
	PrixBase = prixBase
	CoefficientAchat = coefficientAchat
	Level = level
	TypeAmeliorationBore = typeAmeliorationBore
	BonusTypeAmeliorationBore = bonusTypeAmeliorationBore
	BonusAmeliorationBore = bonusAmeliorationBore
	IsBasedUnlocked = isBasedUnlocked
	if not IsUnlocked and IsBasedUnlocked:
		IsUnlocked = true


#Permet de definir le prix pour débloquer un atome.
func DefineAtomeUnlockingPrice(atomePriceForUnlocking):
	AtomePriceForUnlocking = atomePriceForUnlocking


#Récupère le prix d'une amélioration, pour l'instant c'est x10 puissance niveau
func GetPrixAmeliorationBore():
	var basePrix = Big.multiply(PrixBase, Big.power(CoefficientAchat, Level))
	return basePrix
