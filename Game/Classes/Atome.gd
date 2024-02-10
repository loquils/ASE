class_name Atome

var ListeAttribs = []

var Nom

var PrixBaseVenteAtome

var ApportAtome

var AugmentationHydroForce
var AugmentationHydroVitesse

func _init(nom):
	Nom = nom
	
	#ListeAttribs = [AttributAtome.new(self, "Force", 0, 1.2, 1.07, 5), AttributAtome.new(self, "Vitesse", 0, 1.5, 1.10, 10)]
	
	
	PrixBaseVenteAtome = 1.0
	
	ApportAtome = 1.0
	#var coin = CoefficientsRapportAttributs["Force"] * NiveauxAttributs["Force"]
	#var coin2 = CoefficientsRapportAttributs["Vitesse"] * NiveauxAttributs["Vitesse"]

func setAttributs(attributsListe):
	ListeAttribs = attributsListe.duplicate()

func GetPrixAttribut(attribut):
	var prix = attribut.PrixBaseAmelio * pow(attribut.CoefficientAchat, attribut.Niveau)
	return round(prix)

func GetAugmentationsAttributs():
	var attributsAddition = 0
	for attribut in ListeAttribs:
		attributsAddition += attribut.CoefficientRapport * attribut.Niveau
	return attributsAddition
