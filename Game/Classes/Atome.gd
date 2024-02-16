class_name Atome

var isUnlocked = false
var AtomePriceForUnlocking

var Name

var PrixBaseVenteAtome

var ApportAtome

var ListeAttribs = []

func _init(name, apportAtome, prixBaseVenteAtome):
	Name = name
		
	ApportAtome = apportAtome
	PrixBaseVenteAtome = prixBaseVenteAtome
	
	#var coin = CoefficientsRapportAttributs["Force"] * NiveauxAttributs["Force"]
	#var coin2 = CoefficientsRapportAttributs["Vitesse"] * NiveauxAttributs["Vitesse"]

#Permet de définir la liste des attributs de l'atome.
func DefineAtomeAttributs(attributsListe):
	ListeAttribs = attributsListe.duplicate()

#Permet de definir le prix pour débloquer un atome.
func DefineAtomeUnlockingPrice(atomePriceForUnlocking):
	AtomePriceForUnlocking = atomePriceForUnlocking

#Retourne le prix de l'amélioration de l'attribut.
func GetPrixAttribut(attribut):
	var prix = attribut.PrixBaseAmelio * pow(attribut.CoefficientAchat, attribut.Niveau)
	return prix

#Retourne le coefficient d'augmentation des attributs.
func GetAugmentationsAttributs():
	var attributsAddition = 0.0
	for attribut in ListeAttribs:
		attributsAddition += attribut.CoefficientRapport * attribut.Niveau
	return attributsAddition

func GetAtomePerSec():
	if isUnlocked:
		return ApportAtome * (1.0 + GetAugmentationsAttributs())
	else:
		return 0.00
