extends Control

var CanvasPresentation = preload("res://Design/CanvasPresentationAttributs.tscn")

var ListeAtomes

# Called when the node enters the scene tree for the first time.
func _ready():
	#On connecte ici l'appuie du bouton lors de l'achat d'un attribut
	RechercheClick.connect("Attribut_button_pressed", AchatAttributButtonPressed)
	
	var newAtome = Atome.new("Hydrogene")
	var ListeAttribsTest = [AttributAtome.new(newAtome, "Force", 0, 1.2, 1.07, 5), AttributAtome.new(newAtome, "Vitesse", 0, 1.5, 1.10, 10), AttributAtome.new(newAtome, "COIIIn", 0, 2, 2, 50)]
	newAtome.setAttributs(ListeAttribsTest)
	ListeAtomes = {"Hydrogene" : newAtome}
	
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
	
	#if ListeAtomes[posAtome].Achete:
	#	return
	
	if attribut.Atome.GetPrixAttribut(attribut) > RessourceManager.Coins:
		return
	
	attribut.Niveau += 1
	
	RessourceManager.Coins -= attribut.Atome.GetPrixAttribut(attribut)
	print("Attribut " + attribut.Nom + " achetée ! Niveau : " + str(attribut.Niveau))
