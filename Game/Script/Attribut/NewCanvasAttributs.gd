extends Control

var Atome
var AttributBoutton = preload("res://Design/Scenes/Attribut/NewButtonAttribut.tscn")

@onready var AttributButtonsC = $PresentationPanel/PresentationVBoxC/ButtonsMarginC/HBoxC
@onready var NomAtome = $PresentationPanel/PresentationVBoxC/NomAtomeMarginC/NomLabel

@onready var UnlockPanel = $PanelForUnlock


func _set_var(atome):
	Atome = atome

# Called when the node enters the scene tree for the first time.
func _ready():
	UnlockPanel._set_objects(Atome)
	for attribut in Atome.ListeAttribs:
		var newBouton = AttributBoutton.instantiate()
		newBouton._set_var(attribut)
		AttributButtonsC.add_child(newBouton)
	
	#On met ça pour que ce soit set correctement après un reset (surtout dans le process, mais au cas ou quoi)
	if Atome.IsUnlocked:
		UnlockPanel.visible = false
	else:
		UnlockPanel.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	NomAtome.text = tr(Atome.Name)
	
	if UnlockPanel.visible:
		if Atome.IsUnlocked:
			UnlockPanel.visible = false

		#On test si le bouton est disabled ou pas : donc si on a assez de tous les atomes qu'on a besoin
		var testForOk = true
		for priceAtomeName in Atome.AtomePriceForUnlocking:
			if RessourceManager.QuantiteesAtomes[priceAtomeName].isLessThan(Atome.AtomePriceForUnlocking[priceAtomeName]):
				testForOk = false
	
	else:
		if not Atome.IsUnlocked:
			UnlockPanel.visible = true
