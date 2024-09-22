extends Control

var Atome
var AttributBoutton = preload("res://Design/Scenes/Attribut/NewButtonAttribut.tscn")

@onready var AttributButtonsC = $PresentationPanel/PresentationVBoxC/ButtonsMarginC/HBoxC

@onready var UnlockPanel = $PanelForUnlock
@onready var UnlockPanelAtomeLabel = $PanelForUnlock/FondPanel/VBoxC/AtomeLabel
@onready var UnlockPanelPrixLabel = $PanelForUnlock/FondPanel/VBoxC/PrixLabel
@onready var UnlockPanelButton = $PanelForUnlock/FondPanel/VBoxC/UnlockButton

@onready var NomAtome = $PresentationPanel/PresentationVBoxC/NomAtomeMarginC/NomLabel

func _set_var(atome):
	Atome = atome

# Called when the node enters the scene tree for the first time.
func _ready():
	for attribut in Atome.ListeAttribs:
		var newBouton = AttributBoutton.instantiate()
		newBouton._set_var(attribut)
		AttributButtonsC.add_child(newBouton)
		
	if Atome.isUnlocked:
		UnlockPanel.visible = false
	else:
		for atome in Atome.AtomePriceForUnlocking:
			UnlockPanelAtomeLabel.text = tr(atome)
			UnlockPanelPrixLabel.text = str(Atome.AtomePriceForUnlocking[atome])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	NomAtome.text = tr(Atome.Name)
	
	if UnlockPanel.visible:
		if Atome.isUnlocked:
			UnlockPanel.visible = false
		else:
			for atome in Atome.AtomePriceForUnlocking:
				UnlockPanelAtomeLabel.text = tr(atome)
				UnlockPanelPrixLabel.text = str(Atome.AtomePriceForUnlocking[atome])
		
		#On test si le bouton est disabled ou pas : donc si on a assez de tous les atomes qu'on a besoin
		var testForOk = true
		for priceAtomeName in Atome.AtomePriceForUnlocking:
			if RessourceManager.QuantiteesAtomes[priceAtomeName].isLessThan(Atome.AtomePriceForUnlocking[priceAtomeName]):
				testForOk = false
		
		UnlockPanelButton.disabled = not testForOk
	
	else:
		if not Atome.isUnlocked:
			UnlockPanel.visible = true


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
