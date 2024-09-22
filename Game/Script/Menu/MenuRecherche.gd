extends Control

var ButtonRechercheScenePreload = preload("res://Design/Scenes/Recherches/NewButtonRecherche.tscn")

@onready var ResearchesDebutContainer = $MainMarginC/ResearchLvlVBoxC/LvlDebutScrollC/GridC
@onready var ResearchesEasyContainer = $MainMarginC/ResearchLvlVBoxC/LvlEasyScrollC/GridC

@onready var RechercheVBoxC = $MainMarginC/ResearchLvlVBoxC

var ListeScrollCNiveaux


# Called when the node enters the scene tree for the first time.
func _ready():
	#On connecte ici l'appuie du bouton lors de l'achat d'une recherche
	RechercheClick.connect("Research_button_pressed", AchatRehercheButtonPressed)
	
	#On récupère tous les ScrollC de la vue pour afficher/cacher
	ListeScrollCNiveaux = RechercheVBoxC.get_children()
	ListeScrollCNiveaux.remove_at(0)
	
	for recherche in RessourceManager.ListeRecherches:
		var newRecherchebutton = ButtonRechercheScenePreload.instantiate()
		newRecherchebutton._set_var(recherche)
		match recherche.ResearchLevel:
			Recherche.ResearchLevelEnum.DEBUT:
				ResearchesDebutContainer.add_child(newRecherchebutton)
			Recherche.ResearchLevelEnum.EASY:
				ResearchesEasyContainer.add_child(newRecherchebutton)
	
	BonusManager.MajBonusRecherches()


#Methode appellee par le signal lors de l'appuie sur un des boutons de recherches
#On vérifie si on peut acheter la recherche, et on l'achete.	
func AchatRehercheButtonPressed(recherche):
	if recherche.ResearchLevel == Recherche.ResearchLevelEnum.DARKMATTER:
		return
		
	var IdRecherche = RessourceManager.ListeRecherches.find(recherche)
	
	if RessourceManager.ListeRecherches[IdRecherche].IsUnlocked:
		return
	
	if RessourceManager.ListeRecherches[IdRecherche].Prix.isGreaterThan(RessourceManager.Coins):
		return
	
	RessourceManager.ListeRecherches[IdRecherche].IsUnlocked = true
	RessourceManager.Coins = Big.subtractAbove0(RessourceManager.Coins, RessourceManager.ListeRecherches[IdRecherche].Prix)

	BonusManager.MajBonusRecherches()


#Methode apellee lors de l'appuie sur un des boutons de niveau de recherche
#Permet d'afficher les bonnes recherches, et de cacher les autres
func _on_expand_lvl_button_pressed(extra_arg_0):
	for scrollC in ListeScrollCNiveaux:
		if scrollC.name.contains(extra_arg_0):
			scrollC.show()
		else:
			scrollC.hide()
