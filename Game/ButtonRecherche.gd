extends Button

var Recherche

func _set_var(recherche):
	Recherche = recherche
	
	pressed.connect(RechercheClick.RechercheButtonEventTrigger.bind(Recherche))
	pressed.connect(ChangeButtonStateToBought)
	
	$ResearchToBuyVBoxContainer/NomLabel.text = Recherche.Nom
	$ResearchToBuyVBoxContainer/DescriptionLabel.text = Recherche.Description
	$ResearchToBuyVBoxContainer/PrixLabel.text = "Prix : " + str(Recherche.Prix)
	
	$ResearchBoughtVBoxContainer/NomLabel.text = Recherche.Nom
	$ResearchBoughtVBoxContainer/DescriptionLabel.text = Recherche.Description
	$ResearchBoughtVBoxContainer/BonusLabel.text = "+" + str(Recherche.AugmentationPercent) + "%"
	
func _process(_delta):
	#disabled = true
	if not Recherche.Achete:
		if Recherche.Prix <= RessourceManager.Coins:
			disabled = false
		else:
			disabled = true

#Methode trigger lors de l'appuie sur ce bouton
#Si la recherche est bien achetée, il faut changer la stucture du bouton :
func ChangeButtonStateToBought():
	print("Bah ça clique ici :3")
	if Recherche.Achete:
		disabled = true
		$ResearchToBuyVBoxContainer.visible = false
		$ResearchBoughtVBoxContainer.visible = true
		print("Recherche achetée :)")
