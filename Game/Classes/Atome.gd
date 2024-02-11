class_name Atome

var isUnlocked = false
var priceToUnlock = {"Hydrogene" : 100}

var Nom

var PrixBaseVenteAtome

var ApportAtome

var ListeAttribs = []

func _init(nom, apportAtome, prixBaseVenteAtome):
	Nom = nom
		
	ApportAtome = apportAtome
	PrixBaseVenteAtome = prixBaseVenteAtome
	
	#var coin = CoefficientsRapportAttributs["Force"] * NiveauxAttributs["Force"]
	#var coin2 = CoefficientsRapportAttributs["Vitesse"] * NiveauxAttributs["Vitesse"]

func setAttributs(attributsListe):
	ListeAttribs = attributsListe.duplicate()

func GetPrixAttribut(attribut):
	var prix = attribut.PrixBaseAmelio * pow(attribut.CoefficientAchat, attribut.Niveau)
	return prix

func GetAugmentationsAttributs():
	var attributsAddition = 0.0
	for attribut in ListeAttribs:
		attributsAddition += attribut.CoefficientRapport * attribut.Niveau
	return attributsAddition
