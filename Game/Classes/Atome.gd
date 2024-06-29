class_name Atome

var isUnlocked = false
var AtomePriceForUnlocking

var Name

var PrixBaseVenteAtome: Big

var ApportAtomeBase
var ApportAtome

var ListeAttribs = []

var GlobalMultiplicator = Big.new()

func _init(name, apportAtomeBase:Big, prixBaseVenteAtome:Big = Big.new(0.0)):
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
	var niveauPar100 = Big.roundDown(Big.divide(attribut.Niveau, Big.new(1.0,2)))
	var prixAchatBaseAttribut = Big.add(attribut.PrixBaseAmelio, Big.multiply(attribut.PrixBaseAmelio, Big.multiply(niveauPar100, Big.new(1.0, 5))))
	var puissanceCoefficientAchat = Big.power(attribut.CoefficientAchat, attribut.Niveau)
	var prix = Big.divide(Big.multiply(prixAchatBaseAttribut, puissanceCoefficientAchat), BonusManager.GetRecherchesAttributsCostsDivided(attribut))
	return prix


#Retourne le coefficient d'augmentation des attributs.
func GetAugmentationsAttributs():
	var attributsAddition = Big.new(0.0)
	
	for attribut in ListeAttribs:
		attributsAddition = Big.add(attributsAddition, Big.multiply(attribut.CoefficientRapport, attribut.Niveau))
	
	attributsAddition = Big.add(Big.new(1.0), attributsAddition)

	return attributsAddition


#Retourne la quantité d'atome par seconde par rapport aux attribut 
func GetAtomePerSec():
	if isUnlocked:
		#return ApportAtome.multiply((CustomNumber.new(1.0).add(GetAugmentationsAttributs()))).multiply(GlobalMultiplicator)
		return Big.multiply(Big.multiply(ApportAtome, GetAugmentationsAttributs()), BonusManager.GetGlobalMultiplicator(Name))
		#return Big.multiply(ApportAtome, GetAugmentationsAttributs())
	else:
		return Big.new(0.0)
