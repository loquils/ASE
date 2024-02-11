extends Control

var Atome
var AttributBoutton = preload("res://ButtonAttribut.tscn")

func _set_var(atome):
	Atome = atome
	
	$NomAtomeLabel.text = atome.Nom
	
	for attribut in atome.ListeAttribs:
		var newBouton = AttributBoutton.instantiate()
		newBouton._set_var(attribut)
		$HBoxContainer.add_child(newBouton)
		
	if Atome.isUnlocked:
		$PanelForUnlock.visible = false
	
	for priceAtome in Atome.priceToUnlock:
		$PanelForUnlock/VBoxContainer/AtomeLabel.text = priceAtome
		$PanelForUnlock/VBoxContainer/PrixLabel.text = str(Atome.priceToUnlock[priceAtome])

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $PanelForUnlock.visible:
		if Atome.isUnlocked:
			$PanelForUnlock.visible = false
		
		#On test si le bouton est disabled ou pas : donc si on a assez de tous les atomes qu'on a besoin
		var testForOk = true
		for priceAtome in Atome.priceToUnlock:
			if RessourceManager.QuantiteesAtomes[priceAtome] < Atome.priceToUnlock[priceAtome]:
				testForOk = false
		
		if testForOk:
			$PanelForUnlock/VBoxContainer/Button.disabled = false
		else:
			$PanelForUnlock/VBoxContainer/Button.disabled = true
		

func OnUnlockButtonPressed():
	print("Bouton achat atome :" + Atome.Nom)
	if Atome.isUnlocked:
		return
	
	for priceAtome in Atome.priceToUnlock:
		if RessourceManager.QuantiteesAtomes[priceAtome] < Atome.priceToUnlock[priceAtome]:
			return
	
	for priceAtome in Atome.priceToUnlock:
		RessourceManager.QuantiteesAtomes[priceAtome] -= Atome.priceToUnlock[priceAtome]
	
	Atome.isUnlocked = true
	
	print("Bouton achat atome :" + Atome.Nom)
