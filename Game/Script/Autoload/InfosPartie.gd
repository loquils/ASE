extends Node

var CoinsObtenusInThisReset = Big.new(0.0)
var CoinsObtenusTotal = Big.new(0.0)

var DarkMatterObtenuTotal = Big.new(0.0)

var AtomesObtenuInThisReset = {}

var HydrogeneMaximum = Big.new(0.0)

var RecherchesAchetees = 0
var RecherchesMatiereNoireAchetees = 0
var NombrePrestige:int = 0





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
func ResetInformationsOnPrestige(darkMatterObtenu):
	HydrogeneMaximum = Big.new(0.0)
	for atome in AtomesObtenuInThisReset:
		AtomesObtenuInThisReset[atome] = Big.new(0.0)
	
	CoinsObtenusInThisReset = Big.new(0.0)
	CoinsObtenusTotal = Big.add(CoinsObtenusTotal, CoinsObtenusInThisReset)
	DarkMatterObtenuTotal = Big.add(DarkMatterObtenuTotal, darkMatterObtenu)
	NombrePrestige += 1


#Sauvegarde des informations de la partie dans la save.
func Save():
	#Pour les quantitées
	var atomesQuantiteeObtenuDictionnary = {}
	for atomName in AtomesObtenuInThisReset:
		atomesQuantiteeObtenuDictionnary[atomName] = AtomesObtenuInThisReset[atomName].ToJsonFormat()
	
	var infosPartieDictionnary = {
		"NombrePrestige" : NombrePrestige,
		"HydrogeneMaximum" : HydrogeneMaximum.ToJsonFormat(),
		"CoinsObtenusInThisReset" : CoinsObtenusInThisReset.ToJsonFormat(),
		"CoinsObtenusTotal" : CoinsObtenusTotal.ToJsonFormat(),
		"DarkMatterObtenuTotal" : DarkMatterObtenuTotal.ToJsonFormat(),
		"AtomesObtenuInThisReset" : atomesQuantiteeObtenuDictionnary
	}
	return infosPartieDictionnary


#Chargement des informations de la partie dans la save.
func Load(infos):
	InitializeAtomesObtenusInThisReset()
	
	if infos.has("NombrePrestige"):
		NombrePrestige = int(infos["NombrePrestige"])
	if infos.has("HydrogeneMaximum"):
		HydrogeneMaximum = Big.ToCustomFormat(infos["HydrogeneMaximum"])
	if infos.has("CoinsObtenusInThisReset"):
		CoinsObtenusInThisReset = Big.ToCustomFormat(infos["CoinsObtenusInThisReset"])
	if infos.has("CoinsObtenusTotal"):
		CoinsObtenusTotal = Big.ToCustomFormat(infos["CoinsObtenusTotal"])
	if infos.has("DarkMatterObtenuTotal"):
		DarkMatterObtenuTotal = Big.ToCustomFormat(infos["DarkMatterObtenuTotal"])
		if DarkMatterObtenuTotal.isEqualTo(Big.new(0.0)) and not RessourceManager.DarkMatter.isEqualTo(Big.new(0.0)):
			DarkMatterObtenuTotal = RessourceManager.DarkMatter
	if infos.has("AtomesObtenuInThisReset"):
		var atomesObtenusDictionnary = infos["AtomesObtenuInThisReset"]
		for atomeName in atomesObtenusDictionnary:
			if AtomesObtenuInThisReset.has(atomeName):
				AtomesObtenuInThisReset[atomeName] = Big.ToCustomFormat(atomesObtenusDictionnary[atomeName])

#Permet d'initialiser le dictionnaire des atomes obtenus dans ce reset.
func InitializeAtomesObtenusInThisReset():
	for atome in RessourceManager.AtomsListInitializingGame:
		AtomesObtenuInThisReset[atome.Name] = Big.new(0.0)
