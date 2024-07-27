class_name AttributAtome

var Atome

var Name
var Niveau: Big
var CoefficientAchat: Big

var CoefficientBaseRapport: Big

var PrixBaseAmelio: Big

func _init(atome, name, niveau:Big, coefficientAchat:Big, coefficientBaseRapport:Big, prixBaseAmelio:Big):
	Atome = atome
	Name = name
	Niveau = niveau
	CoefficientAchat = coefficientAchat
	CoefficientBaseRapport = coefficientBaseRapport
	PrixBaseAmelio = prixBaseAmelio

#Retourne l'apport d'un attribut d'un atome selon son niveau, prend en compte les bonus
#sur les coefficients et sur le global des coeffs d'un atome. 
func GetAttributRapportAvecNiveau():
	var attributCoefficientApresBonus = CoefficientBaseRapport
	
	#On ajoute les bonus concernant les augmentations sur tous les attributs de l'atome d'hydrogène (bonus helium)
	if BonusManager.CurrentBonusesAmeliorationHelium.has(Atome.Name + "AttributsCoefficientAdd"):
		attributCoefficientApresBonus = Big.add(attributCoefficientApresBonus, BonusManager.GetAmeliorationHeliumTemperatureBonusTotal())
		
	return Big.multiply(attributCoefficientApresBonus, Niveau)
