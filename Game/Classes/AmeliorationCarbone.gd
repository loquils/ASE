class_name AmeliorationCarbone

var Id
var Name
var Description

var UnlockingClass:Unlocking
var IsUnlocked = false
var IsBasedUnlocked = false

var Level: Big

var PrixBase = Big.new(1.0, 3)

var CoefficientAchat: Big

#Permet de définier le niveau d'une molécule
var EtatMolecule = 0

#La molécule affilliée à l'amélioration
var MoleculeUpgrade

enum TypeAmeliorationCarboneEnum {Alcane, Alcene, Alcyne}
var TypeAmeliorationCarbone

var BonusTypeAmeliorationCarbone
var BonusAmeliorationCarbone


var DictionnaryPrefixesNomsEtatsMolecules = ["Meth", "Eth", "Prop", "But", "Pent", "Hex", "Hept", "Oct", "Non", "Dec"]
var DictionnarySuffixesNomsEtatsMolecules = {AmeliorationCarbone.TypeAmeliorationCarboneEnum.Alcane : "ane", AmeliorationCarbone.TypeAmeliorationCarboneEnum.Alcene : "ene", AmeliorationCarbone.TypeAmeliorationCarboneEnum.Alcyne : "yne"} 


func _init(id, name, description, prixBase:Big, coefficientAchat, typeAmeliorationCarbone:TypeAmeliorationCarboneEnum, bonusTypeAmeliorationCarbone, bonusAmeliorationCarbone:Big, isBasedUnlocked = false, level:Big = Big.new(0.0)):
	Id = id
	Name = name
	Description = description
	PrixBase = prixBase
	CoefficientAchat = coefficientAchat
	Level = level
	TypeAmeliorationCarbone = typeAmeliorationCarbone
	#BonusTypeAmeliorationCarbone = bonusTypeAmeliorationCarbone
	#BonusAmeliorationCarbone = bonusAmeliorationCarbone
	IsBasedUnlocked = isBasedUnlocked
	
	#DefineCurrentWorkingMolecule()
	
	if not IsUnlocked and IsBasedUnlocked:
		IsUnlocked = true


#Permet de definir le prix pour débloquer un atome.
func DefineAtomeUnlockingPrice(atomePriceForUnlocking):
	UnlockingClass = Unlocking.new(atomePriceForUnlocking)


#Permet de définir la molécule sur laquelle se base l'amélioration et de reset l'ancienne molécule s'il y en a une.
func DefineCurrentWorkingMolecule():
	if not RessourceManager.ListeAtomes["Carbone"].IsUnlocked:
		return
	
	if not MoleculeUpgrade == null:
		MoleculeUpgrade.IsUnlocked = false
		RessourceManager.QuantiteesMolecules[MoleculeUpgrade.Name] = Big.new(0)
	
	var moleculesTrouveeDansListe = RessourceManager.ListeMolecules.filter(func(moleculeSave): return moleculeSave.Name == GetNomMolecule().to_upper())
	if moleculesTrouveeDansListe.size() == 1:
		moleculesTrouveeDansListe[0].IsUnlocked = true
		
		#On définit un coeff pour les différent type d'améliorations
		var coeffType = 0
		if TypeAmeliorationCarbone == TypeAmeliorationCarboneEnum.Alcene:
			coeffType = 1
		elif TypeAmeliorationCarbone == TypeAmeliorationCarboneEnum.Alcyne:
			coeffType = 2
		
		#On définit quel est le bonus en sortie, en fonction du type et de l'état de la molécule
		var coefMultiplicateurHydrogene = Big.add(Big.new(1.45), Big.new(coeffType * 0.3))
		var etatMolecule = Big.new(EtatMolecule + 1)
		
		var hydrogeneSortie = Big.subtractAbove0(Big.power(coefMultiplicateurHydrogene, etatMolecule), Big.new(1))
		
		var coefMultiplicateurCarbone = Big.add(Big.new(1.0), Big.new(coeffType * 0.1))
		
		moleculesTrouveeDansListe[0].DefineAtomeSortieBonus({"Hydrogene" : coefMultiplicateurHydrogene, "Carbone" : coefMultiplicateurCarbone})
		MoleculeUpgrade = moleculesTrouveeDansListe[0]


#Récupère le prix d'une amélioration, pour l'instant c'est x10 puissance niveau
func GetPrixAmeliorationCarbone():
	var basePrix = Big.multiply(PrixBase, Big.power(CoefficientAchat, Level))
	return basePrix


#Permet de monter l'état d'une molécule.
func UpgradeEtatMolecule():
	if EtatMolecule < len(DictionnaryPrefixesNomsEtatsMolecules) - 1:
		EtatMolecule += 1;
	
	DefineCurrentWorkingMolecule()


#Permet de récupérer le nom d'une molécule en fonction de son état.
func GetNomMolecule():
	return DictionnaryPrefixesNomsEtatsMolecules[EtatMolecule] + DictionnarySuffixesNomsEtatsMolecules[TypeAmeliorationCarbone]
