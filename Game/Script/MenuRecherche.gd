extends Control

var ListeRecherches = []
var ButtonRechercheScenePreload = preload("res://Design/Scenes/ButtonRecherche.tscn")

var CurrentBonusesResearches = {"PrixHydrogenePerCent" : 0.0}

# Called when the node enters the scene tree for the first time.
func _ready():
	ListeRecherches.append(Recherche.new(0, "Coin1", "Améliore 50%.", CustomNumber.new(1.0, 3), "PrixHydrogenePerCent", 50))
	ListeRecherches.append(Recherche.new(1, "Coin2", "Améliore 100%", CustomNumber.new(5.0, 3), "PrixHydrogenePerCent", 100))
	ListeRecherches.append(Recherche.new(2, "Coin3", "Améliore le prix de vente de l'hydrogène de 1 000%.", CustomNumber.new(2.0, 4), "PrixHydrogenePerCent", 1000))
	#ListeRecherches.append(Recherche.new(2, "Coin3", "Améliore 1 000%", 20000, "PrixHydrogenePerCent", 1000))
	#ListeRecherches.append(Recherche.new(3, "Coin4", "Améliore 10 000%", 50000, "PrixHydrogenePerCent", 10000))
	
	#On connecte ici l'appuie du bouton lors de l'achat d'une recherche
	RechercheClick.connect("Research_button_pressed", AchatRehercheButtonPressed)
	
	for recherche in ListeRecherches:
		var newRecherchebutton = ButtonRechercheScenePreload.instantiate()
		newRecherchebutton._set_var(recherche)
		$ScrollContainer/HBoxContainer.add_child(newRecherchebutton)
		
	MajBonusRecherches()
	
	
	
func _process(_delta):
	$HBoxContainer/AugmenteLabel.text = str(CurrentBonusesResearches["PrixHydrogenePerCent"]) + "%"
	
	
	
#Methode appellee par le signal lors de l'appuie sur un des boutons de recherches
#On vérifie si on peut acheter la recherche, et on l'achete.	
func AchatRehercheButtonPressed(recherche):
	print("Bouton préssé :)")
	var posRecherche = ListeRecherches.find(recherche)
	if ListeRecherches[posRecherche].Achete:
		return
	
	if ListeRecherches[posRecherche].Prix.compare(RessourceManager.Coins) > 0:
		return
	
	ListeRecherches[posRecherche].Achete = true
	RessourceManager.Coins = RessourceManager.Coins.minus(ListeRecherches[posRecherche].Prix)
	print("Recherche " + recherche.Name + " achetée !")
	MajBonusRecherches()


#Permet de mettre à jour le dictionnaire des ressources
#On parcour la liste des ressources, et on ajoute les bonus
func MajBonusRecherches():
	CurrentBonusesResearches["PrixHydrogenePerCent"] = 0.0
	for recherche in ListeRecherches:
		if recherche.Achete:
			match recherche.Augmentation:
				"PrixHydrogenePerCent":
					CurrentBonusesResearches["PrixHydrogenePerCent"] = CurrentBonusesResearches["PrixHydrogenePerCent"] + recherche.AugmentationPercent/100.0

