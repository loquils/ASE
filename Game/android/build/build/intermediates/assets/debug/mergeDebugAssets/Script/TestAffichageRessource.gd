extends HBoxContainer

var RessourceName
var RessourceQuantity

func _set_var(ressourceName, ressourceQuantity):
	RessourceName = ressourceName
	RessourceQuantity = ressourceQuantity
	$NameLabel.text = RessourceName
	$QuantityLabel.text = str(RessourceQuantity)


# On met à jour l'UI + on affiche la ressource si elle est bloquée
func _process(delta):
	if visible == true:
		RessourceQuantity = RessourceManager.QuantiteesAtomes[RessourceName]
		$QuantityLabel.text = str(RessourceQuantity)
		$PerSecLabel.text = str(RessourceManager.ListeAtomes[RessourceName].GetAtomePerSec()) + "/s"
	else:
		if RessourceManager.ListeAtomes[RessourceName].isUnlocked:
			show()
