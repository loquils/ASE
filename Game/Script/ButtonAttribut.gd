extends Button

var Attribut

func _set_var(attribut):
	Attribut = attribut
	$VBoxContainer/NomLabel.text = Attribut.Name
	$VBoxContainer/Niveau.text = "Niv." + str(Attribut.Niveau)
	$VBoxContainer/Prix.text = str(Attribut.Atome.GetPrixAttribut(Attribut)) + " C"

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(RechercheClick.AttributButtonEventTrigger.bind(Attribut))

func _process(delta):
	$VBoxContainer/Niveau.text = "Niv." + str(Attribut.Niveau)
	$VBoxContainer/Prix.text = str(Attribut.Atome.GetPrixAttribut(Attribut)) + " C"
	
	if Attribut.Atome.GetPrixAttribut(Attribut) > RessourceManager.Coins:
		disabled = true
	else:
		disabled = false
