extends Button

var Attribut

func _set_var(attribut):
	Attribut = attribut
	$VBoxContainer/NomLabel.text = Attribut.Nom
	$VBoxContainer/Niveau.text = str(Attribut.Niveau)
	#$VBoxContainer/Prix.text = str(Attribut.Niveau)

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(RechercheClick.AttributButtonEventTrigger.bind(Attribut))
