extends Control

var ListeRecherches = []
var but = preload("res://ButtonRecherche.tscn")

var CurrentBonusesResearches = {"PrixHydrogenePerCent" : 0}

# Called when the node enters the scene tree for the first time.
func _ready():
	ListeRecherches.append(Recherche.new(0, "Coin1", "Coiiiiiiiiiiiiiiiiiiiiiiiiiiin !!!", 1000, "PrixHydrogenePerCent", 10))
	ListeRecherches.append(Recherche.new(1, "Coin2", "Coiiiiiiiiiiiiiiiiiiiiiiiiiiin !!!", 1000, "PrixHydrogenePerCent", 100))
	ListeRecherches.append(Recherche.new(2, "Coin3", "Coiiiiiiiiiiiiiiiiiiiiiiiiiiin !!!", 1000, "PrixHydrogenePerCent", 1000))
	ListeRecherches.append(Recherche.new(3, "Coin4", "Coiiiiiiiiiiiiiiiiiiiiiiiiiiin !!!", 1000, "PrixHydrogenePerCent", 10000))
	ListeRecherches.append(Recherche.new(4, "Coin5", "Coiiiiiiiiiiiiiiiiiiiiiiiiiiin !!!", 1000, "PrixHydrogenePerCent", 100000))
	ListeRecherches.append(Recherche.new(5, "Coin6", "Coiiiiiiiiiiiiiiiiiiiiiiiiiiin !!!", 1000, "PrixHydrogenePerCent", 1000000))
	ListeRecherches.append(Recherche.new(6, "Coin7", "Coiiiiiiiiiiiiiiiiiiiiiiiiiiin !!!", 1000, "PrixHydrogenePerCent", 10000000))
	ListeRecherches.append(Recherche.new(7, "Coin8", "Coiiiiiiiiiiiiiiiiiiiiiiiiiiin !!!", 1000, "PrixHydrogenePerCent", 100000000))
	RechercheClick.connect("button_pressed", AchatRehercheButtonPressed)
	
	
	for recherche in ListeRecherches:
		var newRecherchebutton = but.instantiate()
		newRecherchebutton._set_var(recherche)
		$ScrollContainer/HBoxContainer.add_child(newRecherchebutton)

func _process(_delta):
	$HBoxContainer/AugmenteLabel.text = str(CurrentBonusesResearches["PrixHydrogenePerCent"]) + "%"
	#TODO: Il faut changer ça pour opti : on peut s'arreter une fois qu'on à trouvé une recherche qu'on a pas (et mettre toutes celles de derière en non clicable ?)
	for button in $ScrollContainer/HBoxContainer.get_children():
		if not button.Recherche.Achete:
			if button.Recherche.Prix > RessourceManager.Coins:
				button.disabled = true
			else:
				button.disabled = false
	
	
#Methode appellee par le signal lors de l'appuie sur un des boutons de recherches
#On vérifie si on peut acheter la recherche, et on l'achete.	
func AchatRehercheButtonPressed(recherche):
	print("Bouton préssé :)")
	var posRecherche = ListeRecherches.find(recherche)
	if ListeRecherches[posRecherche].Achete:
		return
	
	if ListeRecherches[posRecherche].Prix > RessourceManager.Coins:
		return
	
	ListeRecherches[posRecherche].Achete = true
	RessourceManager.Coins -= ListeRecherches[posRecherche].Prix
	print("Recherche " + recherche.Nom + " achetée !")
	MajBonusRecherches()


#Permet de mettre à jour le dictionnaire des ressources
#On parcour la liste des ressources, et on ajoute les bonus
func MajBonusRecherches():
	CurrentBonusesResearches["PrixHydrogenePerCent"] = 0
	for recherche in ListeRecherches:
		if recherche.Achete:
			match recherche.Augmentation:
				"PrixHydrogenePerCent":
					CurrentBonusesResearches["PrixHydrogenePerCent"] += recherche.AugmentationPercent
