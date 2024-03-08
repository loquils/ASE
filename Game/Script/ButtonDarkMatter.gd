extends Button

var AmeliorationDarkMatter


#Définition de l'UI du bouton personnalisé.
func _set_var(ameliorationDarkMatter):
	AmeliorationDarkMatter = ameliorationDarkMatter
	
	pressed.connect(RechercheClick.AmeliorationDarkMatterButtonEventTrigger.bind(AmeliorationDarkMatter))
	pressed.connect(ChangeButtonStateToBought)
	
	$PanelContainer/ResearchToBuyVBoxContainer/NomLabel.text = AmeliorationDarkMatter.Name
	$PanelContainer/ResearchToBuyVBoxContainer/MarginContainer/DescriptionLabel.text = AmeliorationDarkMatter.Description
	$PanelContainer/ResearchToBuyVBoxContainer/PrixLabel.text = "Prix : " + str(AmeliorationDarkMatter.Prix)


#On met a jour l'UI en bloquant le bouton :)
func _process(_delta):
	if not AmeliorationDarkMatter.IsUnlocked:
		if AmeliorationDarkMatter.Prix.compare(RessourceManager.Coins) <= 0:
			disabled = false
		else:
			disabled = true
	else:
		if not $PanelC/PresentationVBoxC/MarginC/Panel.visible:
			ChangeButtonStateToBought()


#Methode trigger lors de l'appuie sur ce bouton
#Si la recherche est bien achetée, il faut changer la stucture du bouton :
func ChangeButtonStateToBought():
	if AmeliorationDarkMatter.IsUnlocked:
		disabled = true
		$PanelC/PresentationVBoxContainer/MarginC/Panel.visible = true
		print("Recherche achetée :)")
