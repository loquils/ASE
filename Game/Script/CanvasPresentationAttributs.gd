extends Control

var Atome
var AttributBoutton = preload("res://Design/Scenes/ButtonAttribut.tscn")

func _set_var(atome):
	Atome = atome
	
	$NomAtomeLabel.text = atome.Name
	
	for attribut in atome.ListeAttribs:
		var newBouton = AttributBoutton.instantiate()
		newBouton._set_var(attribut)
		$HBoxContainer.add_child(newBouton)
		
	if Atome.isUnlocked:
		$PanelForUnlock.visible = false
	else:
		for priceAtome in Atome.AtomePriceForUnlocking:
			$PanelForUnlock/VBoxContainer/AtomeLabel.text = priceAtome
			$PanelForUnlock/VBoxContainer/PrixLabel.text = str(Atome.AtomePriceForUnlocking[priceAtome]._to_string())

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
		for priceAtomeName in Atome.AtomePriceForUnlocking:
			RessourceManager.QuantiteesAtomes[priceAtomeName].prints()
			Atome.AtomePriceForUnlocking[priceAtomeName].prints()
			if RessourceManager.QuantiteesAtomes[priceAtomeName].compare(Atome.AtomePriceForUnlocking[priceAtomeName]) < 0:
				testForOk = false
		
		if testForOk:
			$PanelForUnlock/VBoxContainer/Button.disabled = false
		else:
			$PanelForUnlock/VBoxContainer/Button.disabled = true
		

func OnUnlockButtonPressed():
	print("Bouton achat atome :" + Atome.Name)
	if Atome.isUnlocked:
		return
	
	for priceAtomeName in Atome.AtomePriceForUnlocking:
		if RessourceManager.QuantiteesAtomes[priceAtomeName].compare(Atome.AtomePriceForUnlocking[priceAtomeName]) < 0:
			return
	
	for priceAtomeName in Atome.AtomePriceForUnlocking:
		RessourceManager.QuantiteesAtomes[priceAtomeName] = RessourceManager.QuantiteesAtomes[priceAtomeName].minus(Atome.AtomePriceForUnlocking[priceAtomeName])
	
	Atome.isUnlocked = true
	
	print("Bouton achat atome :" + Atome.Name)
