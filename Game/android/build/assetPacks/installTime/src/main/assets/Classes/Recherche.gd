class_name Recherche

var Id
var Name
var Description
var Prix
var IsUnlocked = false
var Augmentation:Array
var AugmentationPercent
var ResearchLevel:ResearchLevelEnum

enum ResearchLevelEnum {DEBUT, EASY}

func _init(id, name, description, prix: Big, augmentation, augmentationPercent: Big, researchLevel):
	Id = id
	Name = name
	Description = description
	Prix = prix
	Augmentation = augmentation
	AugmentationPercent = augmentationPercent
	ResearchLevel = researchLevel

#Permet de get le bonus de la recherche (si c'est par recherches achetées, ça récupère le bonus total du coup)
func GetRechercheBonus():
	var currentBonus = AugmentationPercent
	if Augmentation[0].contains("ParRecherche"):
		currentBonus = Big.multiply(currentBonus, InfosPartie.RecherchesAchetees)
	
	return currentBonus

#Permet de construire la chaine de char à afficher celon le type de la recherche
func GetRechercheBonusString():
	var bonus = GetRechercheBonus()
	
	if Augmentation[0].contains("OutputMultiply") or Augmentation[0].contains("PrixHydrogeneAugmentation") or Augmentation[0].contains("CoefficientMultiply"):
		return "+" + str(Big.multiply(bonus, Big.new(1.0, 2))) + "%"
	
	if Augmentation[0].contains("CostDivided"):
		return "/" + str(bonus)
