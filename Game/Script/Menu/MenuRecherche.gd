extends Control

var ButtonRechercheScenePreload = preload("res://Design/Scenes/ButtonRecherche.tscn")

var CurrentBonusesResearches = {"PrixHydrogenePerCent" : 0.0}


# Called when the node enters the scene tree for the first time.
func _ready():
	#On connecte ici l'appuie du bouton lors de l'achat d'une recherche
	RechercheClick.connect("Research_button_pressed", AchatRehercheButtonPressed)
	
	for recherche in RessourceManager.ListeRecherches:
		var newRecherchebutton = ButtonRechercheScenePreload.instantiate()
		newRecherchebutton._set_var(recherche)
		match recherche.ResearchLevel:
			Recherche.ResearchLevelEnum.EASY:
				$ScrollContainerGlobalMenu/ResearchLvlVBoxContainer/ScrollRecherchesContainer/Control/ResearchesEasyHBoxContainer.add_child(newRecherchebutton)
		
	MajBonusRecherches()


func _process(_delta):
	$HBoxContainer/AugmenteLabel.text = str(CurrentBonusesResearches["PrixHydrogenePerCent"]) + "%"


#Methode appellee par le signal lors de l'appuie sur un des boutons de recherches
#On vérifie si on peut acheter la recherche, et on l'achete.	
func AchatRehercheButtonPressed(recherche):
	print("Bouton préssé :)")
	if RessourceManager.ListeRecherches[recherche.Id].IsUnlocked:
		return
	
	if RessourceManager.ListeRecherches[recherche.Id].Prix.compare(RessourceManager.Coins) > 0:
		return
	
	RessourceManager.ListeRecherches[recherche.Id].IsUnlocked = true
	RessourceManager.Coins = RessourceManager.Coins.minus(RessourceManager.ListeRecherches[recherche.Id].Prix)
	print("Recherche " + recherche.Name + " achetée !")
	MajBonusRecherches()


#Permet de mettre à jour le dictionnaire des ressources
#On parcour la liste des ressources, et on ajoute les bonus
func MajBonusRecherches():
	CurrentBonusesResearches["PrixHydrogenePerCent"] = 0.0
	for recherche in RessourceManager.ListeRecherches:
		if recherche.IsUnlocked:
			match recherche.Augmentation:
				"PrixHydrogenePerCent":
					CurrentBonusesResearches["PrixHydrogenePerCent"] = CurrentBonusesResearches["PrixHydrogenePerCent"] + recherche.AugmentationPercent/100.0


var isEasyButtonExpanded = true
func _on_expand_lvl_easy_button_pressed():
	isEasyButtonExpanded = not isEasyButtonExpanded
	$ScrollContainerGlobalMenu/ResearchLvlVBoxContainer/ScrollRecherchesContainer/Control/ResearchesEasyHBoxContainer.visible = isEasyButtonExpanded
