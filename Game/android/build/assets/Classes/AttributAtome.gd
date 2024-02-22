class_name AttributAtome

var Atome

var Name
var Niveau
var CoefficientAchat

var CoefficientBaseRapport
var CoefficientRapport

var PrixBaseAmelio

func _init(atome, name, niveau:CustomNumber, coefficientAchat:CustomNumber, coefficientBaseRapport:CustomNumber, prixBaseAmelio:CustomNumber):
	Atome = atome
	Name = name
	Niveau = niveau
	CoefficientAchat = coefficientAchat
	CoefficientBaseRapport = coefficientBaseRapport
	CoefficientRapport = CoefficientBaseRapport
	PrixBaseAmelio = prixBaseAmelio

