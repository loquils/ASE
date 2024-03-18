extends Button

var Attribut

func _set_var(attribut):
	Attribut = attribut
	$PanelContainer/VBoxContainer/NomLabel.text = Attribut.Name
	$PanelContainer/VBoxContainer/Niveau.text = "Niv." + str(Attribut.Niveau)
	$PanelContainer/VBoxContainer/Prix.text = str(Attribut.Atome.GetPrixAttribut(Attribut)) + " C"

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(RechercheClick.AttributButtonEventTrigger.bind(Attribut))

func _process(delta):
	$PanelContainer/VBoxContainer/Niveau.text = "Niv." + str(Attribut.Niveau)
	$PanelContainer/VBoxContainer/Prix.text = str(Attribut.Atome.GetPrixAttribut(Attribut)) + " C"
	
	if Attribut.Atome.GetPrixAttribut(Attribut).isGreaterThan(RessourceManager.Coins):
		disabled = true
	else:
		disabled = false
