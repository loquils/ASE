class_name Atome

var isUnlocked = false
var AtomePriceForUnlocking

var Name

var PrixBaseVenteAtome

var ApportAtomeBase
var ApportAtome

var ListeAttribs = []

var GlobalMultiplicator = CustomNumber.new(1.0)

func _init(name, apportAtomeBase:CustomNumber, prixBaseVenteAtome:CustomNumber = CustomNumber.new()):
	Name = name
		
	ApportAtomeBase = apportAtomeBase
	ApportAtome = ApportAtomeBase
	
	PrixBaseVenteAtome = prixBaseVenteAtome


#Permet de définir la liste des attributs de l'atome.
func DefineAtomeAttributs(attributsListe):
	ListeAttribs = attributsListe.duplicate()


#Permet de definir le prix pour débloquer un atome.
func DefineAtomeUnlockingPrice(atomePriceForUnlocking):
	AtomePriceForUnlocking = atomePriceForUnlocking


#Retourne le prix de l'amélioration de l'attribut.
func GetPrixAttribut(attribut):
	var poww = attribut.CoefficientAchat.power(attribut.Niveau)
	var prix = attribut.PrixBaseAmelio.multiply(poww)
	return prix


#Retourne le coefficient d'augmentation des attributs.
func GetAugmentationsAttributs():
	var attributsAddition = CustomNumber.new()
	for attribut in ListeAttribs:
		attributsAddition = attributsAddition.add(attribut.CoefficientRapport.multiply(attribut.Niveau))
	return attributsAddition


#Retourne la quantité d'atome par seconde par rapport aux attribut 
func GetAtomePerSec():
	if isUnlocked:
		return ApportAtome.multiply((CustomNumber.new(1.0).add(GetAugmentationsAttributs()))).multiply(GlobalMultiplicator)
	else:
		return CustomNumber.new()
