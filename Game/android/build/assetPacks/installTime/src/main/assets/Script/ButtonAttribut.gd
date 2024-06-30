extends Button

var Attribut

@onready var NomLabel = $PanelContainer/VBoxContainer/NomLabel
@onready var NiveauLabel = $PanelContainer/VBoxContainer/Niveau
@onready var PrixLabel = $PanelContainer/VBoxContainer/Prix

func _set_var(attribut):
	Attribut = attribut


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(RechercheClick.AttributButtonEventTrigger.bind(Attribut))
	NomLabel.text = tr(Attribut.Name)
	NiveauLabel.text = tr("Niv.") + str(Attribut.Niveau)
	PrixLabel.text = str(Attribut.Atome.GetPrixAttribut(Attribut))#TODO: Round a ish 4~5 chiffre ? 

func _process(delta):
	NomLabel.text = tr(Attribut.Name)
	NiveauLabel.text = tr("Niv.") + str(Attribut.Niveau)
	PrixLabel.text = str(Attribut.Atome.GetPrixAttribut(Attribut))
	
	if Attribut.Atome.GetPrixAttribut(Attribut).isGreaterThan(RessourceManager.Coins):
		disabled = true
	else:
		disabled = false
