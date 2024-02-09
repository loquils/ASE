class_name Atome

var AttributForce = AttributAtome.new("Force", 0, 1.2, 1.07, 5)

var Nom

var NiveauxAttributs
var CoefficientsAchatAttributs
var CoefficientsRapportAttributs

var PrixBaseAmelioAttributs

var PrixBaseVenteAtome

var ApportAtome

var AugmentationHydroForce
var AugmentationHydroVitesse

func _init(nom):
	Nom = nom
	
	NiveauxAttributs = {"Force" : 0, "Vitesse" : 0}
	CoefficientsAchatAttributs = {"Force" : 1.2, "Vitesse" : 1.5}
	CoefficientsRapportAttributs = {"Force" : 1.07, "Vitesse" : 1.10}
	
	PrixBaseAmelioAttributs = {"Force" : 5, "Vitesse" : 10}
	
	PrixBaseVenteAtome = 1.0
	
	ApportAtome = 1.0
	
	AugmentationHydroForce =  CoefficientsRapportAttributs["Force"] * NiveauxAttributs["Force"]
	AugmentationHydroVitesse = CoefficientsRapportAttributs["Vitesse"] * NiveauxAttributs["Vitesse"]
