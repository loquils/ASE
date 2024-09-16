extends Control

var CanvasPresentation = preload("res://Design/Scenes/Attribut/NewCanvasAttributs.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#On connecte ici l'appuie du bouton lors de l'achat d'un attribut
	RechercheClick.connect("Attribut_button_pressed", AchatAttributButtonPressed)
	
	#Il faut générer un canvas de présentation avec Nom, et une liste de boutons
	for atomeNom in RessourceManager.ListeAtomes:
		var newAtomeCanvas = CanvasPresentation.instantiate()
		newAtomeCanvas._set_var(RessourceManager.ListeAtomes[atomeNom])
		$ScrollContainer/VBoxContainer.add_child(newAtomeCanvas)



#Trigger lors de l'appuie sur un bouton pour augmenter un attribut d'un atome
func AchatAttributButtonPressed(attribut):
	if attribut.Atome.GetPrixAttribut(attribut).isLessThan(RessourceManager.Coins):#and attribut.Atome.GetPrixAttribut(attribut).isGreaterThan(Big.new(0.0)):
		RessourceManager.Coins = Big.subtractAbove0(RessourceManager.Coins, attribut.Atome.GetPrixAttribut(attribut))
		attribut.Niveau = Big.add(attribut.Niveau, Big.new(1.0))
		#Pour tous lvl 100 passé, on multiplie les coefficient par 2
		#if Big.roundDown(Big.divide(attribut.Niveau, Big.new(1.0,2)).isEqualTo(Big.divide(attribut.Niveau, Big.new(1.0,2))):
			#var multiplieur = Big.multiply(attribut.)
