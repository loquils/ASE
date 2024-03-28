extends Control

@onready var CoinsQuantityLabel = $WindowTopBlackVBoxC/MarginContainer/MainVBoxC/TopHBoxC/RessourcesVBoxC/BackGroundCoins/MarginC/HBoxC/CoinsLabel
var AdButtonScene = preload("res://Design/Scenes/AdButton.tscn")

func _ready():
	MobileAds.initialize()


func _process(_delta):
		#var prix = round(coin.PrixBaseAmelioAttributs["Force"] * pow(coin.CoefficientsAchatAttributs["Force"], coin.NiveauxAttributs["Force"]))
	CoinsQuantityLabel.text = str(RessourceManager.Coins)


#func GetPrixVenteHydrogene():
#	var newPrix = Big.multiply(RessourceManager.AtomsList["Hydrogene"].PrixBaseVenteAtome, RessourceManager.CurrentBonusesAmeliorationHelium["HydrogeneRendementMultiply"])


func _on_main_timer_timeout():
	RessourceManager.CalculateQuantityAtomes(1)


#Bouton pour hard_reset
func _on_button_pressed():
	Save.hard_reset()


#Trigger lors de l'appuie sur le bouton pour ouvrir la page d'améliorations de l'helium 
func _on_button_amelioration_helium_pressed():
	$WindowTopBlackVBoxC/MarginContainer/AmeliorationHeliumControl.visible = true


func _on_button_menu_prestige_pressed():
	$WindowTopBlackVBoxC/MarginContainer/AmeliorationDarkMatterControl.visible = true


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


func _on_max_hydro_timer_timeout():
	if RessourceManager.HydrogeneMax.isLessThan(RessourceManager.QuantiteesAtomes["Hydrogene"]):
		RessourceManager.HydrogeneMax = RessourceManager.QuantiteesAtomes["Hydrogene"]


func _on_ad_timer_timeout():
	if not has_node("WindowTopBlackVBoxC/MarginContainer/MainVBoxC/TopHBoxC/VBoxBoutons/AdButton"):
		var buttonAd = AdButtonScene.instantiate()
		$WindowTopBlackVBoxC/MarginContainer/MainVBoxC/TopHBoxC/VBoxBoutons.add_child(buttonAd)
	else:
		print("coiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiin")
