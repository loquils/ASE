class_name AttributAtome

var Atome

var Name
var Niveau: Big
var CoefficientAchat: Big

var CoefficientBaseRapport: Big
var CoefficientRapport

var PrixBaseAmelio: Big

func _init(atome, name, niveau:Big, coefficientAchat:Big, coefficientBaseRapport:Big, prixBaseAmelio:Big):
	Atome = atome
	Name = name
	Niveau = niveau
	CoefficientAchat = coefficientAchat
	CoefficientBaseRapport = coefficientBaseRapport
	CoefficientRapport = CoefficientBaseRapport
	PrixBaseAmelio = prixBaseAmelio
