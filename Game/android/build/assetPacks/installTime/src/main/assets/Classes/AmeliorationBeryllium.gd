class_name AmeliorationBeryllium

var Id
var Name
var Description

var AtomePriceForUnlocking = {"Beryllium" : Big.new(1.0, 2)}
var IsUnlocked = false
var IsBasedUnlocked = false

var Level: Big

var PrixBase = {"Hydrogene" : Big.new(1.0, 0)}

var CoefficientAchat: Big

enum CategorieAmeliorationBerylliumEnum {Normal, BonusAdd}
var CategorieAmeliorationBeryllium

#Définie la quantité de level dans chacune des 4 catégories qu'ajoute la recherche (recherche Normal)
#Définie la quantité à ajouter à chacunes des 4 catégories de chaques recherches (recherche BonusAdd)
var BonusTypeAmeliorationBeryllium = ["Hydrogene", "Helium", "Lithium", "Beryllium"]
var BonusesAmeliorationBeryllium


func _init(id, name, description, prixBase, coefficientAchat, categorieAmeliorationBeryllium:CategorieAmeliorationBerylliumEnum, bonusesAmeliorationBeryllium, isBasedUnlocked = false, level:Big = Big.new(0.0)):
	Id = id
	Name = name
	Description = description
	PrixBase = prixBase
	CoefficientAchat = coefficientAchat
	Level = level
	CategorieAmeliorationBeryllium = categorieAmeliorationBeryllium
	BonusesAmeliorationBeryllium = bonusesAmeliorationBeryllium
	IsBasedUnlocked = isBasedUnlocked
	if not IsUnlocked and IsBasedUnlocked:
		IsUnlocked = true


#Permet de definir le prix pour débloquer l'amélioration.
func DefineUnlockingPrice(atomePriceForUnlocking):
	AtomePriceForUnlocking = atomePriceForUnlocking


#Permet de get le prix de l'amélioration (avec l'atome en prix)
func GetPrixAmeliorationBeryllium():
	return {PrixBase.keys()[0] : Big.multiply(PrixBase.values()[0], Big.power(CoefficientAchat, Level))}


#Récupère les quantitée d'ajouts de la recherche
func GetBonusesArray():
	var bonusAvecNiveaux = [0, 0, 0, 0]
	var bonusAddNumberBeryllium = BonusManager.GetAmeliorationBerylliumNumberAddBonuses()
	var i = 0
	for bonus in BonusesAmeliorationBeryllium:
		var numberAfterAdding = Big.add(bonus, bonusAddNumberBeryllium[i])
		bonusAvecNiveaux[i] = Big.multiply(numberAfterAdding, Level)
		i += 1
	return bonusAvecNiveaux
