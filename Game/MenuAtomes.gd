extends Control

var CanvasPresentation = preload("res://Design/CanvasPresentationAttributs.tscn")

var ListeAtomes

# Called when the node enters the scene tree for the first time.
func _ready():
	#On connecte ici l'appuie du bouton lors de l'achat d'un attribut
	RechercheClick.connect("Attribut_button_pressed", AchatAttributButtonPressed)
	
	ListeAtomes = {"Hydrogene" : Atome.new("Hydrogene")}
	
	#Il faut générer un canvas de présentation avec Nom, et une liste de boutons
	for atomeNom in ListeAtomes:
		var newAtomeCanvas = CanvasPresentation.instantiate()
		newAtomeCanvas._set_var(ListeAtomes[atomeNom])
		$ScrollContainer/HBoxContainer.add_child(newAtomeCanvas)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func AchatAttributButtonPressed(attribut):
	print(attribut.Nom)
