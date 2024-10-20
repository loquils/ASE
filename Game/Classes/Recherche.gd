class_name Recherche

var Id
var Name
var Description
var Prix
var IsUnlocked = false
var Augmentation:Array
var AugmentationPercent
var ResearchLevel:ResearchLevelEnum

enum ResearchLevelEnum {DARKMATTER, DEBUT, EASY, LESSEASY}

func _init(id, name, prix: Big, augmentation, augmentationPercent: Big, researchLevel):
	Id = id
	Name = name
	Prix = prix
	Augmentation = augmentation
	AugmentationPercent = augmentationPercent
	ResearchLevel = researchLevel
	Description = GetRechercheDescription()

#Permet de get le bonus de la recherche (si c'est par recherches achetées, ça récupère le bonus total du coup)
func GetRechercheBonus():
	var currentBonus = AugmentationPercent
	if Augmentation[0].contains("ParRechercheMN"):
		currentBonus = Big.multiply(currentBonus, InfosPartie.RecherchesMatiereNoireAchetees)
	elif Augmentation[0].contains("ParRecherche"):
		currentBonus = Big.multiply(currentBonus, InfosPartie.RecherchesAchetees)

	return currentBonus


#Permet de définir la description de la recherche selon la méthode de génération automatique des messages.
func GetRechercheDescription():
	var result = ""

	var augmentation = Augmentation[0]
	if augmentation.contains("PrixHydrogeneAugmentation"):
		result = augmentation.to_upper()
	if augmentation.contains("OutputMultiply"):
		result = "OutputMultiply".to_upper()
	if augmentation.contains("CostDivided"):
		result = "CostDivided".to_upper()
	if augmentation.contains("CoefficientMultiply"):
		result = "CoefficientMultiply".to_upper()
	if augmentation.contains("ParRechercheMN"):
		result += "ParRechercheMN".to_upper()
	elif augmentation.contains("ParRecherche"):
		result += "ParRecherche".to_upper()
		
	if result == "":
		return "RECHERCHEDESCRIPTION" + str(Id + 1)
	else:
		return result

#Permet de recupérer les différents éléments impactés par la recherche.
func GetRechercheElements():
	if Augmentation[0].contains("AmeliorationHelium") or Augmentation[0].contains("AmeliorationsHe"):
		var resultAmeliorationHelium = []
		for augmentation in Augmentation:
			if Augmentation[0].contains("OutputMultiply"):
				var upgrade = augmentation.replace("AmeliorationHelium", "").replace("ParRechercheMN", "").replace("ParRecherche", "").replace("OutputMultiply", "")
				var nomRecherche = RessourceManager.ListeAmeliorationsHelium.filter(func(amelioration): return amelioration.Id == int(upgrade))
				if nomRecherche.size() == 1:
					resultAmeliorationHelium.append(tr(nomRecherche[0].Name))
			else:
				var upgrade = augmentation.replace("AmeliorationHelium", "").replace("ParRechercheMN", "").replace("ParRecherche", "").replace("CostDivided", "")
				if upgrade.contains("AmeliorationsHe"):
					return [tr("AMELIORATIONSHE")]
				resultAmeliorationHelium.append(tr("AMELIORATIONHELIUM" + str(int(upgrade) + 1)))
		return resultAmeliorationHelium
	
	if Augmentation[0].contains("AmeliorationLithium") or Augmentation[0].contains("AmeliorationsLithium"):
		var resultAmeliorationLithium = []
		for augmentation in Augmentation:
			var upgrade = augmentation.replace("AmeliorationLithium", "").replace("ParRechercheMN", "").replace("ParRecherche", "").replace("CostDivided", "")
			if upgrade.contains("AmeliorationsLithium"):
				return [tr("AMELIORATIONSLITHIUM")]
			var nomRecherche = RessourceManager.ListeAmeliorationsLithium.filter(func(amelioration): return amelioration.Id == int(upgrade))
			if nomRecherche.size() == 1:
				resultAmeliorationLithium.append(tr(nomRecherche[0].Name))
			else:
				resultAmeliorationLithium.append(tr("AMELIORATIONLITHIUM" + str(int(upgrade) + 1)))
		return resultAmeliorationLithium
	
	if Augmentation[0].contains("OutputMultiply"):
		var resultOutputMultiply = []
		for augmentation in Augmentation:
			var atome = augmentation.replace("OutputMultiply", "").replace("ParRechercheMN", "").replace("ParRecherche", "")
			if atome.contains("All"):
				return [tr("ALLATOMES")]
			resultOutputMultiply.append(tr(atome))
		return resultOutputMultiply
	
	if Augmentation[0].contains("CostDivided"):
		if Augmentation[0].contains("AmeliorationsHe"):
			return [tr("Ameliorations") + tr("Helium")]
		
		var resultCostDivided = []
		for augmentation in Augmentation:
			var attribut = augmentation.replace("CostDivided", "").replace("ParRechercheMN", "").replace("ParRecherche", "")
			if attribut.contains("Attributs"):
				resultCostDivided.append(tr(attribut.replace("Attributs", "")))
			else:
				resultCostDivided.append(GetAttributCostDividedName(attribut))
		return resultCostDivided
	
	if Augmentation[0].contains("CoefficientMultiply"):
		var resultCoefficientMultiply = []
		for augmentation in Augmentation:
			var attribut = augmentation.replace("CoefficientMultiply", "").replace("ParRechercheMN", "").replace("ParRecherche", "")
			if Id == 23:
				var coin = "coin"
			if attribut.contains("Attributs"):
				resultCoefficientMultiply.append(tr(attribut.replace("Attributs", "")))
			else:
				resultCoefficientMultiply.append(GetAttributCostDividedName(attribut))
		return resultCoefficientMultiply
	
	return [""]


#Permet de construire la chaine de caractères à afficher : attribut et atome
func GetAttributCostDividedName(attributName):
	for atomeName in RessourceManager.ListeAtomes:
		if attributName.contains(atomeName):
			return tr(attributName.replace(atomeName, "")) + " (" + tr(atomeName).trim_prefix(" ") + ")" 
	return ""


#Permet de récupérer le bonus unique de la recherche selon son type
func GetRechercheString():
	if Augmentation[0].contains("OutputMultiply") or Augmentation[0].contains("PrixHydrogeneAugmentation") or Augmentation[0].contains("CoefficientMultiply"):
		return str(Big.multiply(AugmentationPercent, Big.new(1.0, 2))) + "%"
	if Augmentation[0].contains("CostDivided"):
		return str(AugmentationPercent)
	return ""


#Permet de construire la chaine de char à afficher selon le type de la recherche
func GetRechercheBonusString():
	var bonus = GetRechercheBonus()
	
	if Augmentation[0].contains("OutputMultiply") or Augmentation[0].contains("PrixHydrogeneAugmentation") or Augmentation[0].contains("CoefficientMultiply"):
		return "+" + str(Big.multiply(bonus, Big.new(1.0, 2))) + "%"
	
	if Augmentation[0].contains("CostDivided"):
		return "/" + str(bonus)
