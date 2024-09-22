extends Node

var CoinsObtenusInThisReset = Big.new(0.0)
var CoinsObtenusTotal = Big.new(0.0)

var HydrogeneMaximum = Big.new(0.0)
var HydrogeneObtenuInThisReset = Big.new(0.0)

var RecherchesAchetees = 0
var RecherchesMatiereNoireAchetees = 0
var NombrePrestige:int = 0

#Permet de mettre à jour toutes les informations sur la partie
func MajInformationsPartie():
	if HydrogeneMaximum.isLessThan(RessourceManager.QuantiteesAtomes["Hydrogene"]):
		HydrogeneMaximum = RessourceManager.QuantiteesAtomes["Hydrogene"]
	
	RecherchesAchetees = 0
	for recherche in RessourceManager.ListeRecherches:
		if recherche.IsUnlocked:
			RecherchesAchetees += 1
	
	RecherchesMatiereNoireAchetees = 0
	for rechercheMatiereNoire in RessourceManager.ListeRecherchesMatiereNoire:
		if rechercheMatiereNoire.IsUnlocked:
			RecherchesMatiereNoireAchetees += 1


#Permet de faire un reset de prestige sur les informations de la partie
func ResetInformationsOnPrestige():
	HydrogeneMaximum = Big.new(0.0)
	CoinsObtenusInThisReset = Big.new(0.0)
	HydrogeneObtenuInThisReset = Big.new(0.0)
	CoinsObtenusTotal = Big.add(CoinsObtenusTotal, CoinsObtenusInThisReset)
	NombrePrestige += 1


#Sauvegarde des informations de la partie dans la save.
func Save():
	var infosPartieDict = {
		"NombrePrestige" : NombrePrestige,
		"HydrogeneMaximum" : HydrogeneMaximum.ToJsonFormat(),
		"HydrogeneObtenuInThisReset" : HydrogeneObtenuInThisReset.ToJsonFormat(),
		"CoinsObtenusInThisReset" : CoinsObtenusInThisReset.ToJsonFormat(),
		"CoinsObtenusTotal" : CoinsObtenusTotal.ToJsonFormat()
	}
	return infosPartieDict

#Chargement des informations de la partie dans la save.
func Load(infos):
	if infos.has("NombrePrestige"):
		NombrePrestige = int(infos["NombrePrestige"])
	if infos.has("HydrogeneMaximum"):
		HydrogeneMaximum = Big.ToCustomFormat(infos["HydrogeneMaximum"])
	if infos.has("HydrogeneObtenu"):
		HydrogeneObtenuInThisReset = Big.ToCustomFormat(infos["HydrogeneObtenuInThisReset"])
	if infos.has("CoinsObtenusInThisReset"):
		CoinsObtenusInThisReset = Big.ToCustomFormat(infos["CoinsObtenusInThisReset"])
	if infos.has("CoinsObtenusTotal"):
		CoinsObtenusTotal = Big.ToCustomFormat(infos["CoinsObtenusTotal"])
