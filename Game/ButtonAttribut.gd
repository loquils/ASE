extends Button

var Attribut

func _set_var(attribut):
	Attribut = attribut
	$VBoxContainer/NomLabel.text = Attribut.Nom
	$VBoxContainer/Niveau.text = str(Attribut.Niveau)
	$VBoxContainer/Prix.text = str(Attribut.Atome.GetPrixAttribut(Attribut))

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(RechercheClick.AttributButtonEventTrigger.bind(Attribut))

func _process(delta):
	$VBoxContainer/Niveau.text = str(Attribut.Niveau)
	$VBoxContainer/Prix.text = str(Attribut.Atome.GetPrixAttribut(Attribut))
	
	if Attribut.Atome.GetPrixAttribut(Attribut) > RessourceManager.Coins:
		disabled = true
	else:
		disabled = false
