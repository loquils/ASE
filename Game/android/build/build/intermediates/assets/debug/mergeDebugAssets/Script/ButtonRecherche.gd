extends Button

var ResearchToBuycontainer

var Recherche

#Définition de l'UI du bouton personnalisé.
func _set_var(recherche):
	Recherche = recherche
	
	pressed.connect(RechercheClick.RechercheButtonEventTrigger.bind(Recherche))
	pressed.connect(ChangeButtonStateToBought)
	
	$PanelContainer/ResearchToBuyVBoxContainer/NomLabel.text = Recherche.Name
	$PanelContainer/ResearchToBuyVBoxContainer/MarginContainer/DescriptionLabel.text = Recherche.Description
	$PanelContainer/ResearchToBuyVBoxContainer/PrixLabel.text = "Prix : " + str(Recherche.Prix)



#On met a jour l'UI en bloquant le bouton :)
func _process(_delta):
	if not Recherche.IsUnlocked:
		if Recherche.Prix.compare(RessourceManager.Coins) <= 0:
			disabled = false
		else:
			disabled = true
	else:
		if not $PanelContainer/ResearchToBuyVBoxContainer/MarginContainer/Panel.visible:
			ChangeButtonStateToBought()


#Methode trigger lors de l'appuie sur ce bouton
#Si la recherche est bien achetée, il faut changer la stucture du bouton :
func ChangeButtonStateToBought():
	if Recherche.IsUnlocked:
		disabled = true
		$PanelContainer/ResearchToBuyVBoxContainer/MarginContainer/Panel.visible = true
		print("Recherche achetée :)")
