extends Button

var Attribut

func _set_var(attribut):
	Attribut = attribut
	print("Dans attribut " + attribut.Name)
	print(str(Attribut.Niveau) + " | " + str(Attribut.Atome.GetPrixAttribut(Attribut)))
	$VBoxContainer/NomLabel.text = Attribut.Name
	$VBoxContainer/Niveau.text = "Niv." + str(Attribut.Niveau)
	$VBoxContainer/Prix.text = str(Attribut.Atome.GetPrixAttribut(Attribut)) + " C"

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(RechercheClick.AttributButtonEventTrigger.bind(Attribut))

func _process(delta):
	$VBoxContainer/Niveau.text = "Niv." + Attribut.Niveau._to_string()
	$VBoxContainer/Prix.text = Attribut.Atome.GetPrixAttribut(Attribut)._to_string() + " C"
	
	if Attribut.Atome.GetPrixAttribut(Attribut).compare(RessourceManager.Coins) > 0:
		disabled = true
	else:
		disabled = false
