extends Control

var ButtonRechercheScenePreload = preload("res://Design/Scenes/ButtonRecherche.tscn")

#@onready var ResearchesEasyContainer = $MainMarginC/ResearchLvlVBoxC/ScrollRecherchesC/ResearchesEasyHBoxC
@onready var ResearchesEasyContainer = $MainMarginC/ResearchLvlVBoxC/ScrollContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	#On connecte ici l'appuie du bouton lors de l'achat d'une recherche
	RechercheClick.connect("Research_button_pressed", AchatRehercheButtonPressed)
	
	for recherche in RessourceManager.ListeRecherches:
		var newRecherchebutton = ButtonRechercheScenePreload.instantiate()
		newRecherchebutton._set_var(recherche)
		match recherche.ResearchLevel:
			Recherche.ResearchLevelEnum.EASY:
				ResearchesEasyContainer.add_child(newRecherchebutton)
		
	BonusManager.MajBonusRecherches()



#Methode appellee par le signal lors de l'appuie sur un des boutons de recherches
#On vérifie si on peut acheter la recherche, et on l'achete.	
func AchatRehercheButtonPressed(recherche):
	if RessourceManager.ListeRecherches[recherche.Id].IsUnlocked:
		return
	
	if RessourceManager.ListeRecherches[recherche.Id].Prix.isGreaterThan(RessourceManager.Coins):
		return
	
	RessourceManager.ListeRecherches[recherche.Id].IsUnlocked = true
	RessourceManager.Coins = Big.subtractAbove0(RessourceManager.Coins, RessourceManager.ListeRecherches[recherche.Id].Prix)

	BonusManager.MajBonusRecherches()


var isEasyButtonExpanded = true
func _on_expand_lvl_easy_button_pressed():
	isEasyButtonExpanded = not isEasyButtonExpanded
	ResearchesEasyContainer.visible = isEasyButtonExpanded
