class_name AmeliorationCarbone

var Id
var Name
var Description

var UnlockingClass:Unlocking
var IsUnlocked = false
var IsBasedUnlocked = false

var Level: Big

var PrixBase = Big.new(1.0, 3)

var CoefficientAchat: Big

var EtatMolecule = 0

enum TypeAmeliorationCarboneEnum {Alcane, Alcene, Alcyne}
var TypeAmeliorationCarbone

var BonusTypeAmeliorationCarbone
var BonusAmeliorationCarbone


var DictionnaryPrefixesNomsEtatsMolecules
var DictionnarySuffixesNomsEtatsMolecules = {AmeliorationCarbone.TypeAmeliorationCarboneEnum.Alcane : "ane", AmeliorationCarbone.TypeAmeliorationCarboneEnum.Alcene : "ène", AmeliorationCarbone.TypeAmeliorationCarboneEnum.Alcyne : "yne"} 


func _init(id, name, description, prixBase:Big, coefficientAchat, typeAmeliorationCarbone:TypeAmeliorationCarboneEnum, bonusTypeAmeliorationCarbone, bonusAmeliorationCarbone:Big, isBasedUnlocked = false, level:Big = Big.new(0.0)):
	SetNomsEtatsMolecules()
	Id = id
	Name = name
	Description = description
	PrixBase = prixBase
	CoefficientAchat = coefficientAchat
	Level = level
	TypeAmeliorationCarbone = typeAmeliorationCarbone
	#BonusTypeAmeliorationCarbone = bonusTypeAmeliorationCarbone
	#BonusAmeliorationCarbone = bonusAmeliorationCarbone
	IsBasedUnlocked = isBasedUnlocked
	if not IsUnlocked and IsBasedUnlocked:
		IsUnlocked = true


#Permet de definir le prix pour débloquer un atome.
func DefineAtomeUnlockingPrice(atomePriceForUnlocking):
	UnlockingClass = Unlocking.new(atomePriceForUnlocking)


#Récupère le prix d'une amélioration, pour l'instant c'est x10 puissance niveau
func GetPrixAmeliorationCarbone():
	var basePrix = Big.multiply(PrixBase, Big.power(CoefficientAchat, Level))
	return basePrix


#Permet de monter l'état d'une molécule.
func UpgradeEtatMolecule():
	EtatMolecule += 1;


#Permet de récupérer le nom d'une molécule en fonction de son état.
func GetNomMolecule():
	return DictionnaryPrefixesNomsEtatsMolecules[EtatMolecule] + DictionnarySuffixesNomsEtatsMolecules[TypeAmeliorationCarbone]


#Permet de définir les préfixes et les suffixes des noms des molécules.
func SetNomsEtatsMolecules():
	DictionnaryPrefixesNomsEtatsMolecules = ["Méth", "Eth", "Prop", "But", "Pent", "Hex", "Hept", "Oct", "Non", "Déc"]
