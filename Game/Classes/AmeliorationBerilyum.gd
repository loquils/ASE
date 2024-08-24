class_name AmeliorationBerilyum

var Id
var Name
var Description

var AtomePriceForUnlocking = {"Berilyum" : Big.new(1.0, 2)}
var IsUnlocked = false

var Level: Big

var PrixBase = Big.new(1.0, 0)

var CoefficientAchat: Big

enum CategorieAmeliorationBerilyumEnum {Normal, BonusAdd}
var CategorieAmeliorationBerilyum

#Définie la quantité de level dans chacune des 4 catégories qu'ajoute la recherche (recherche Normal)
#Définie la quantité à ajouter à chacunes des 4 catégories de chaques recherches (recherche BonusAdd)
var BonusTypeAmeliorationBerilyum = ["Hydrogene", "Helium", "Lithium", "Berilyum"]
var BonusesAmeliorationBerilyum


func _init(id, name, description, prixBase:Big, coefficientAchat, categorieAmeliorationBerilyum:CategorieAmeliorationBerilyumEnum, bonusesAmeliorationBerilyum, level:Big = Big.new(0.0)):
	Id = id
	Name = name
	Description = description
	PrixBase = prixBase
	CoefficientAchat = coefficientAchat
	Level = level
	CategorieAmeliorationBerilyum = categorieAmeliorationBerilyum
	BonusesAmeliorationBerilyum = bonusesAmeliorationBerilyum


#Permet de definir le prix pour débloquer l'amélioration.
func DefineUnlockingPrice(atomePriceForUnlocking):
	AtomePriceForUnlocking = atomePriceForUnlocking


func GetPrixAmeliorationBerilyum():
	return Big.multiply(PrixBase, Big.power(CoefficientAchat, Level))


#Récupère les quantitée d'ajouts de la recherche
func GetBonusesArray():
	var bonusAvecNiveaux = [0, 0, 0, 0]
	var bonusAddNumberBerilyum = BonusManager.GetAmeliorationBerilyumNumberAddBonuses()
	var i = 0
	for bonus in BonusesAmeliorationBerilyum:
		var numberAfterAdding = Big.add(bonus, bonusAddNumberBerilyum[i])
		bonusAvecNiveaux[i] = Big.multiply(numberAfterAdding, Level)
		i += 1
	return bonusAvecNiveaux
