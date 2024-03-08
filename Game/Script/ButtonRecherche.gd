extends Button

var Recherche

#Définition de l'UI du bouton personnalisé.
func _set_var(recherche):
	Recherche = recherche
	
	pressed.connect(RechercheClick.RechercheButtonEventTrigger.bind(Recherche))
	pressed.connect(ChangeButtonStateToBought)
	
	$PanelC/PresentationVBoxC/NomLabel.text = Recherche.Name
	$PanelC/PresentationVBoxC/MarginC/DescriptionLabel.text = Recherche.Description
	$PanelC/PresentationVBoxC/PrixLabel.text = "Prix : " + str(Recherche.Prix)



#On met a jour l'UI en bloquant le bouton :)
func _process(_delta):
	if not Recherche.IsUnlocked:
		if Recherche.Prix.compare(RessourceManager.Coins) <= 0:
			disabled = false
		else:
			disabled = true
	else:
		if not $PanelC/PresentationVBoxC/MarginC/Panel.visible:
			ChangeButtonStateToBought()


#Methode trigger lors de l'appuie sur ce bouton
#Si la recherche est bien achetée, il faut changer la stucture du bouton :
func ChangeButtonStateToBought():
	if Recherche.IsUnlocked:
		disabled = true
		$PanelC/PresentationVBoxContainer/MarginC/Panel.visible = true
		print("Recherche achetée :)")
