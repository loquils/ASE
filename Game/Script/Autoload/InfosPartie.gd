extends Node

var CoinsObtenusInThisReset = Big.new(0.0)
var CoinsObtenusTotal = Big.new(0.0)

var AtomesObtenuInThisReset = {}

var HydrogeneMaximum = Big.new(0.0)

var RecherchesAchetees = 0
var RecherchesMatiereNoireAchetees = 0
var NombrePrestige:int = 0

func _ready():
	for atome in RessourceManager.AtomsListInitializingGame:
		AtomesObtenuInThisReset[atome.Name] = Big.new(0.0)

#Permet de mettre à jour toutes les informations sur la partie
func MajInformationsPartie():
	if HydrogeneMaximum.isLessThan(RessourceManager.QuantiteesAtomes["Hydrogene"]):
		HydrogeneMaximum = RessourceManager.QuantiteesAtomes["Hydrogene"]

	RecherchesAchetees = GetNombreRecherchesAchetees()
	RecherchesMatiereNoireAchetees = GetNombreRecherchesMatiereNoireAchetees()


#Permet de calculer la quantitée de recherches achetées avec les bonus.
func GetNombreRecherchesAchetees():
	var recherchesAcheteesAvantBonus = 0
	for recherche in RessourceManager.ListeRecherches:
		if recherche.IsUnlocked:
			recherchesAcheteesAvantBonus += 1
	
	var bonusRecherchesAchetees = BonusManager.GetRecherchesBonusNombreRecherchesAchetees()
	return Big.multiply(recherchesAcheteesAvantBonus, Big.add(Big.new(1.0), bonusRecherchesAchetees))


#Permet de calculer la quantitée de recherches achetées avec les bonus.
func GetNombreRecherchesMatiereNoireAchetees():
	var recherchesMatiereNoireAcheteesAvantBonus = 0
	for rechercheMatiereNoire in RessourceManager.ListeRecherchesMatiereNoire:
		if rechercheMatiereNoire.IsUnlocked:
			recherchesMatiereNoireAcheteesAvantBonus += 1
	
	var bonusRecherchesMatiereNoireAchetees = BonusManager.GetRecherchesBonusNombreRecherchesMatiereNoireAchetees()
	return Big.multiply(recherchesMatiereNoireAcheteesAvantBonus, Big.add(Big.new(1.0), bonusRecherchesMatiereNoireAchetees))


#Permet de faire un reset de prestige sur les informations de la partie
func ResetInformationsOnPrestige():
	AtomesObtenuInThisReset
	HydrogeneMaximum = Big.new(0.0)
	for atome in AtomesObtenuInThisReset:
		AtomesObtenuInThisReset[atome] = Big.new(0.0)
	
	CoinsObtenusInThisReset = Big.new(0.0)
	CoinsObtenusTotal = Big.add(CoinsObtenusTotal, CoinsObtenusInThisReset)
	NombrePrestige += 1


#Sauvegarde des informations de la partie dans la save.
func Save():
	#Pour les quantitées
	var atomesQuantiteeObtenuDictionnary = {}
	for atomName in AtomesObtenuInThisReset:
		atomesQuantiteeObtenuDictionnary[atomName] = AtomesObtenuInThisReset[atomName].ToJsonFormat()
	
	var infosPartieDict = {
		"NombrePrestige" : NombrePrestige,
		"HydrogeneMaximum" : HydrogeneMaximum.ToJsonFormat(),
		"CoinsObtenusInThisReset" : CoinsObtenusInThisReset.ToJsonFormat(),
		"CoinsObtenusTotal" : CoinsObtenusTotal.ToJsonFormat(),
		"AtomesObtenuInThisReset" : atomesQuantiteeObtenuDictionnary
	}
	return infosPartieDict


#Chargement des informations de la partie dans la save.
func Load(infos):
	if infos.has("NombrePrestige"):
		NombrePrestige = int(infos["NombrePrestige"])
	if infos.has("HydrogeneMaximum"):
		HydrogeneMaximum = Big.ToCustomFormat(infos["HydrogeneMaximum"])
	if infos.has("CoinsObtenusInThisReset"):
		CoinsObtenusInThisReset = Big.ToCustomFormat(infos["CoinsObtenusInThisReset"])
	if infos.has("CoinsObtenusTotal"):
		CoinsObtenusTotal = Big.ToCustomFormat(infos["CoinsObtenusTotal"])
	if infos.has("AtomesObtenuInThisReset"):
		var atomesObtenusDictionnary = infos["AtomesObtenuInThisReset"]
		for atomeName in atomesObtenusDictionnary:
			if AtomesObtenuInThisReset.has(atomeName):
				AtomesObtenuInThisReset[atomeName] = Big.ToCustomFormat(atomesObtenusDictionnary[atomeName])
