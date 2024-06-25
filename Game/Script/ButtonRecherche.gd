extends Button

var Recherche

@onready var NomLabel = $PanelC/PresentationVBoxC/NomMarginC/NomLabel
@onready var DescriptionLabel = $PanelC/PresentationVBoxC/MarginC/DescriptionLabel
@onready var PrixLabel = $PanelC/PresentationVBoxC/PrixMarginC/PrixLabel
@onready var VertPanel = $PanelC/PresentationVBoxC/MarginC/VertPanel

#Définition de l'UI du bouton personnalisé.
func _set_var(recherche):
	Recherche = recherche

func _ready():
	pressed.connect(RechercheClick.RechercheButtonEventTrigger.bind(Recherche))
	pressed.connect(ChangeButtonStateToBought)

#On met a jour l'UI en bloquant le bouton :)
func _process(_delta):
	NomLabel.text = tr(Recherche.Name)
	DescriptionLabel.text = tr(Recherche.Description)
	PrixLabel.text = tr("Prix : ") + str(Recherche.Prix)
	
	if not Recherche.IsUnlocked:
		if VertPanel.visible:
			disabled = false
			VertPanel.visible = false
			
		if Recherche.Prix.isGreaterThan(RessourceManager.Coins):
			disabled = true
		else:
			disabled = false
	else:
		if not VertPanel.visible:
			ChangeButtonStateToBought()


#Methode trigger lors de l'appuie sur ce bouton
#Si la recherche est bien achetée, il faut changer la stucture du bouton :
func ChangeButtonStateToBought():
	if Recherche.IsUnlocked:
		disabled = true
		VertPanel.visible = true
		print("Recherche achetée :)")
