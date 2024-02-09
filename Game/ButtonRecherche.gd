extends Button

var ResearchToBuycontainer

var Recherche

#Définition de l'UI du bouton personnalisé.
func _set_var(recherche):
	Recherche = recherche
	
	pressed.connect(RechercheClick.RechercheButtonEventTrigger.bind(Recherche))
	pressed.connect(ChangeButtonStateToBought)
	
	$PanelContainer/ResearchToBuyVBoxContainer/NomLabel.text = Recherche.Nom
	$PanelContainer/ResearchToBuyVBoxContainer/MarginContainer/DescriptionLabel.text = Recherche.Description
	$PanelContainer/ResearchToBuyVBoxContainer/PrixLabel.text = "Prix : " + str(Recherche.Prix)



#On met a jour l'UI en bloquant le bouton :)
func _process(_delta):
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
		#$PanelContainer/ResearchToBuyVBoxContainer.visible = false
		#$PanelContainer/ResearchBoughtVBoxContainer.visible = true
		$PanelContainer/ResearchToBuyVBoxContainer/MarginContainer/Panel.visible = true
		print("Recherche achetée :)")
