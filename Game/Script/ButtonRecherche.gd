extends Button

var Recherche

#Définition de l'UI du bouton personnalisé.
func _set_var(recherche):
	Recherche = recherche

func _ready():
	pressed.connect(RechercheClick.RechercheButtonEventTrigger.bind(Recherche))
	pressed.connect(ChangeButtonStateToBought)

#On met a jour l'UI en bloquant le bouton :)
func _process(_delta):
	$PanelC/PresentationVBoxC/NomLabel.text = tr(Recherche.Name)
	$PanelC/PresentationVBoxC/MarginC/DescriptionLabel.text = tr(Recherche.Description)
	$PanelC/PresentationVBoxC/PrixLabel.text = tr("Prix : ") + str(Recherche.Prix)
	
	if not Recherche.IsUnlocked:
		if $PanelC/PresentationVBoxC/MarginC/Panel.visible:
			disabled = false
			$PanelC/PresentationVBoxC/MarginC/Panel.visible = false
			
		if Recherche.Prix.isGreaterThan(RessourceManager.Coins):
			disabled = true
		else:
			disabled = false
	else:
		if not $PanelC/PresentationVBoxC/MarginC/Panel.visible:
			ChangeButtonStateToBought()


#Methode trigger lors de l'appuie sur ce bouton
#Si la recherche est bien achetée, il faut changer la stucture du bouton :
func ChangeButtonStateToBought():
	if Recherche.IsUnlocked:
		disabled = true
		$PanelC/PresentationVBoxC/MarginC/Panel.visible = true
		print("Recherche achetée :)")
