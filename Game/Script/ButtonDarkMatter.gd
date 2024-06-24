extends Button

var RechercheDarkMatter

@onready var NomAmeliorationLabel = $PanelC/PresentationVBoxC/NomLabel
@onready var DescriptionAmeliorationLabel = $PanelC/PresentationVBoxC/MarginC/DescriptionLabel
@onready var PrixAmeliorationLabel = $PanelC/PresentationVBoxC/PrixLabel


#Définition de l'UI du bouton personnalisé.
func _set_var(rechercheDarkMatter):
	RechercheDarkMatter = rechercheDarkMatter
	
	pressed.connect(RechercheClick.RechercheDarkMatterButtonEventTrigger.bind(RechercheDarkMatter))
	pressed.connect(ChangeButtonStateToBought)


#On met a jour l'UI en bloquant le bouton :)
func _process(_delta):
	NomAmeliorationLabel.text = RechercheDarkMatter.Name
	DescriptionAmeliorationLabel.text = RechercheDarkMatter.Description
	PrixAmeliorationLabel.text = tr("Prix : ") + str(RechercheDarkMatter.Prix)
	
	if not RechercheDarkMatter.IsUnlocked:
		if RechercheDarkMatter.Prix.isGreaterThan(RessourceManager.DarkMatter):
			disabled = true
		else:
			disabled = false
	else:
		if not $PanelC/PresentationVBoxC/MarginC/Panel.visible:
			ChangeButtonStateToBought()


#Methode trigger lors de l'appuie sur ce bouton
#Si la recherche est bien achetée, il faut changer la stucture du bouton :
func ChangeButtonStateToBought():
	if RechercheDarkMatter.IsUnlocked:
		disabled = true
		$PanelC/PresentationVBoxC/MarginC/Panel.visible = true
		print("Recherche Dark Matter achetée :)")
