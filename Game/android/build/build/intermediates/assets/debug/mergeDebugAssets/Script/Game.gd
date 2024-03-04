extends Control


@onready var CoinsQuantityLabel = $WindowTopBlackVBoxC/MarginContainer/MainVBoxC/TopHBoxC/RessourcesVBoxC/BackGroundCoins/MarginC/HBoxC/CoinsLabel

func _ready():
	pass


func _process(_delta):
	CoinsQuantityLabel.text = str(RessourceManager.Coins)
	#var prix = round(coin.PrixBaseAmelioAttributs["Force"] * pow(coin.CoefficientsAchatAttributs["Force"], coin.NiveauxAttributs["Force"]))
	
	
func GetPrixVenteHydrogene():
	var newPrix = RessourceManager.ListeAtomes["Hydrogene"].PrixBaseVenteAtome.multiply(RessourceManager.CurrentBonusesAmeliorationHelium["HydrogeneRendementMultiply"])


func _on_main_timer_timeout():
	for atome in RessourceManager.ListeAtomes:
		if RessourceManager.ListeAtomes[atome].isUnlocked:
			RessourceManager.QuantiteesAtomes[atome] = RessourceManager.QuantiteesAtomes[atome].add(RessourceManager.ListeAtomes[atome].GetAtomePerSec())






func _on_button_pressed():
	Save.hard_reset()


#Trigger lors de l'appuie sur le bouton pour ouvrir la page d'améliorations de l'helium
func _on_button_amelioration_helium_pressed():
	$WindowTopBlackVBoxC/MarginContainer/AmeliorationHeliumControl.visible = true


func _on_save_timer_timeout():
	Save.save_game()


func _notification(what):
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		Save.save_game()


func _on_button_give_money_pressed():
	RessourceManager.Coins = RessourceManager.Coins.add(CustomNumber.new(1.0, 10))
