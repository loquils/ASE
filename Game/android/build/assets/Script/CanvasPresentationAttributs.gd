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
			$PanelForUnlock/VBoxContainer/PrixLabel.text = str(Atome.AtomePriceForUnlocking[priceAtome])

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
			if RessourceManager.QuantiteesAtomes[priceAtomeName].isLessThan(Atome.AtomePriceForUnlocking[priceAtomeName]):
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
		if RessourceManager.QuantiteesAtomes[priceAtomeName].isLessThan(Atome.AtomePriceForUnlocking[priceAtomeName]):
			return
	
	for priceAtomeName in Atome.AtomePriceForUnlocking:
		RessourceManager.QuantiteesAtomes[priceAtomeName] = Big.subtractAbove0(RessourceManager.QuantiteesAtomes[priceAtomeName], Atome.AtomePriceForUnlocking[priceAtomeName])
	
	Atome.isUnlocked = true
	
	print("Bouton achat atome :" + Atome.Name)
