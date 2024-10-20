extends Control

@onready var AccueilControl = $WindowTopBlackVBoxC/AccueilControl
@onready var SaveTimer = $SaveTimer
@onready var MainTimer = $MainTimer
@onready var InformationsPartieTimer = $InformationsPartieTimer
@onready var AdTimer = $AdTimer
@onready var MainMarginC = $WindowTopBlackVBoxC/MainMarginC

@onready var CoinsQuantityLabel = $WindowTopBlackVBoxC/MainMarginC/MainVBoxC/TopHBoxC/RessourcesVBoxC/BackGroundCoins/MarginC/HBoxC/CoinsLabel
@onready var AmeliorationHeliumControl = $WindowTopBlackVBoxC/MainMarginC/AmeliorationHeliumControl
@onready var AmeliorationLithiumControl = $WindowTopBlackVBoxC/MainMarginC/AmeliorationLithiumControl
@onready var AmeliorationBerylliumControl = $WindowTopBlackVBoxC/MainMarginC/AmeliorationBerylliumControl
@onready var AmeliorationBoreControl = $WindowTopBlackVBoxC/MainMarginC/AmeliorationBoreControl
@onready var MatiereNoireControl = $WindowTopBlackVBoxC/MainMarginC/MatiereNoireControl

@onready var OptionsControl = $WindowTopBlackVBoxC/MainMarginC/OptionsControl
@onready var TutorielControl = $WindowTopBlackVBoxC/MainMarginC/TutorielControl

@onready var ButtonMenuAmeliorationHelium = $WindowTopBlackVBoxC/MainMarginC/MainVBoxC/NewMenuMainControl/MenuPresentationVBoxC/AllMenus/MenuAmelioration/MarginContainer/GridContainer/HeliumAmeliorationMarginC/ButtonAmeliorationHelium
@onready var ButtonMenuAmeliorationLithium = $WindowTopBlackVBoxC/MainMarginC/MainVBoxC/NewMenuMainControl/MenuPresentationVBoxC/AllMenus/MenuAmelioration/MarginContainer/GridContainer/LithiumAmeliorationMarginC/ButtonAmeliorationLithium
@onready var ButtonMenuAmeliorationBeryllium = $WindowTopBlackVBoxC/MainMarginC/MainVBoxC/NewMenuMainControl/MenuPresentationVBoxC/AllMenus/MenuAmelioration/MarginContainer/GridContainer/BerylliumAmeliorationMarginC/ButtonAmeliorationBeryllium
@onready var ButtonMenuAmeliorationBore = $WindowTopBlackVBoxC/MainMarginC/MainVBoxC/NewMenuMainControl/MenuPresentationVBoxC/AllMenus/MenuAmelioration/MarginContainer/GridContainer/BoreAmeliorationMarginC/ButtonAmeliorationBore

var AdButtonScene = preload("res://Design/Scenes/AdButton.tscn")

func _ready():
	MobileAds.initialize()


func _process(_delta):
		#var prix = round(coin.PrixBaseAmelioAttributs["Force"] * pow(coin.CoefficientsAchatAttributs["Force"], coin.NiveauxAttributs["Force"]))
	CoinsQuantityLabel.text = str(RessourceManager.Coins)
	ButtonMenuAmeliorationHelium.disabled = not RessourceManager.ListeAtomes["Helium"].isUnlocked
	ButtonMenuAmeliorationLithium.disabled = not RessourceManager.ListeAtomes["Lithium"].isUnlocked
	ButtonMenuAmeliorationBeryllium.disabled = not RessourceManager.ListeAtomes["Beryllium"].isUnlocked
	ButtonMenuAmeliorationBore.disabled = not RessourceManager.ListeAtomes["Bore"].isUnlocked

#func GetPrixVenteHydrogene():
#	var newPrix = Big.multiply(RessourceManager.AtomsList["Hydrogene"].PrixBaseVenteAtome, RessourceManager.CurrentBonusesAmeliorationHelium["HydrogeneRendementMultiply"])


#Main Timer, 1s, permet de calculer la quantité d'atome que l'on gagne
func _on_main_timer_timeout():
	RessourceManager.CalculateQuantityAtomes(1)
	InfosPartie.HydrogeneObtenuInThisReset = Big.add(InfosPartie.HydrogeneObtenuInThisReset, RessourceManager.CalculateQuantityOneAtome("Hydrogene", 1))


#Trigger lors de l'appuie sur le bouton pour ouvrir la page d'améliorations de l'helium 
func _on_button_amelioration_helium_pressed():
	AmeliorationHeliumControl.visible = true


#Trigger lors de l'appuie sur le bouton pour ouvrir la page d'améliorations du lithium
func _on_button_amelioration_lithium_pressed():
	AmeliorationLithiumControl.visible = true


#Trigger lors de l'appuie sur le bouton pour ouvrir la page d'améliorations du beryllium
func _on_button_amelioration_beryllium_pressed():
	AmeliorationBerylliumControl.visible = true


#Trigger lors de l'appuie sur le bouton pour ouvrir la page d'améliorations du beryllium
func _on_button_amelioration_bore_pressed():
	AmeliorationBoreControl.visible = true


#Trigger lors de l'appuie sur le bouton pour ouvrir la page de prestige 
func _on_button_menu_prestige_pressed():
	MatiereNoireControl.visible = true


#Trigger lors de l'appuie sur le bouton pour ouvrir la page d'options 
func _on_options_button_pressed():
	OptionsControl.visible = true


#Permet de save toutes les minutes
func _on_save_timer_timeout():
	Save.save_game()


#On catch la fermeture de l'application sur le téléphone ainsi que quand l'appli est mise en pause
#On lance la save dans les deux cas
func _notification(what):
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		Save.save_game()


#Give give money
func _on_button_give_money_pressed():
	RessourceManager.Coins = Big.add(RessourceManager.Coins, Big.new(1.0, 10))


#Trigger lors de la fin du timer InformationsPartie
#Lance la mise à jour des informations de la partie
func _on_informations_partie_timer_timeout():
	InfosPartie.MajInformationsPartie()


func _on_ad_timer_timeout():
	if not has_node("WindowTopBlackVBoxC/MainMarginC/MainVBoxC/TopHBoxC/VBoxBoutons/AdButton"):
		var buttonAd = AdButtonScene.instantiate()
		$WindowTopBlackVBoxC/MainMarginC/MainVBoxC/TopHBoxC/VBoxBoutons.add_child(buttonAd)


#Trigger lors de l'appuie sur le bouton Jouer de la page d'accueil
func _on_debut_jeu_button_pressed():
	AccueilControl.hide()
	MainMarginC.show()
	SaveTimer.start()
	MainTimer.start()
	InformationsPartieTimer.start()
	#AdTimer.start()
	TutorielControl.AfterAccueil = true


#Permet de changer la langue en français depuis la fenetre d'accueil
func _on_francais_button_pressed():
	LangueManager.maj_langue("fr")


#Permet de changer la langue en anglais depuis la fenetre d'accueil
func _on_anglais_button_pressed():
	LangueManager.maj_langue("en")
