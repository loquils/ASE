extends VBoxContainer

var AffichageRessourceSceneLoad = preload("res://Design/Scenes/PresentationQuantiteesAtomes.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#Creation de la liste des Ressources que l'on possède
	for ressource in RessourceManager.QuantiteesAtomes:
		var newAffichage = AffichageRessourceSceneLoad.instantiate()
		newAffichage._set_var(ressource, RessourceManager.QuantiteesAtomes[ressource])
		add_child(newAffichage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
