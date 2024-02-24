extends Control

var CanvasPresentation = preload("res://Design/Scenes/CanvasPresentationAttributs.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#On connecte ici l'appuie du bouton lors de l'achat d'un attribut
	RechercheClick.connect("Attribut_button_pressed", AchatAttributButtonPressed)
	
	#Il faut générer un canvas de présentation avec Nom, et une liste de boutons
	for atomeNom in RessourceManager.ListeAtomes:
		var newAtomeCanvas = CanvasPresentation.instantiate()
		newAtomeCanvas._set_var(RessourceManager.ListeAtomes[atomeNom])
		$ScrollContainer/VBoxContainer.add_child(newAtomeCanvas)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#Trigger lors de l'appuie sur un bouton pour augmenter un attribut d'un atome
func AchatAttributButtonPressed(attribut):
	if attribut.Atome.GetPrixAttribut(attribut).compare(RessourceManager.Coins) < 0 and attribut.Atome.GetPrixAttribut(attribut).compare(CustomNumber.new()) > 0:
		RessourceManager.Coins = RessourceManager.Coins.minus(attribut.Atome.GetPrixAttribut(attribut))
		attribut.Niveau = attribut.Niveau.add(CustomNumber.new(1.0))
		print("Attribut " + attribut.Name + " achetée ! Niveau : " + str(attribut.Niveau))
		attribut.Atome.GetPrixAttribut(attribut).prints()
