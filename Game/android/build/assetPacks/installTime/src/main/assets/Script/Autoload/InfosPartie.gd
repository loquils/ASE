extends Node

var HydrogeneMaximum = Big.new(0.0)
var HydrogeneObtenu = Big.new(0.0)
var RecherchesAchetees = 0
var RecherchesMatiereNoireAchetees = 0
var NombrePrestige = 0


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
	HydrogeneObtenu = Big.add(HydrogeneObtenu, RessourceManager.QuantiteesAtomes["Hydrogene"])
	NombrePrestige += 1

func Save():
	var infosPartieDict = {
		"NombrePrestige" : NombrePrestige,
		"HydrogeneMaximum" : HydrogeneMaximum,
		"HydrogeneObtenu" : HydrogeneObtenu
	}
	return infosPartieDict

func Load(infos):
	if infos.has("NombrePrestige"):
		NombrePrestige = infos["NombrePrestige"]
	if infos.has("HydrogeneMaximum"):
		NombrePrestige = infos["HydrogeneMaximum"]
	if infos.has("HydrogeneObtenu"):
		NombrePrestige = infos["HydrogeneObtenu"]
