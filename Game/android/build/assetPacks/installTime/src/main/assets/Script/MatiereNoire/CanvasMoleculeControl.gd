extends Control

var Molecule:Molecule

@onready var NomLabel = $PanelC/MainVBoxC/NomMarginC/NomLabel
@onready var QuantityLabel = $PanelC/MainVBoxC/MainMarginC/MainHBoxC/MoleculeViewPanelC/VBoxC/QuantiteeMarginC/HBoxC/QuantityLabel
@onready var BonusLabel = $PanelC/MainVBoxC/MainMarginC/MainHBoxC/MoleculeViewPanelC/VBoxC/BonusMarginC/HBoxC/BonusLabel
@onready var AtomesBonus = $PanelC/MainVBoxC/MainMarginC/MainHBoxC/MoleculeViewPanelC/VBoxC/BonusMarginC/HBoxC/Label

@onready var UnlockPanel = $PanelForUnlock
@onready var UnlockButton = $PanelForUnlock/FondPanel/VBoxContainer/MoleculeUnlockButton
@onready var UnlockAtomeNomLabel = $PanelForUnlock/FondPanel/VBoxContainer/AtomeLabel
@onready var UnlockAtomePrixLabel = $PanelForUnlock/FondPanel/VBoxContainer/PrixLabel

#Définition de l'UI du canvas.
func _set_var(molecule:Molecule):
	Molecule = molecule


func _ready():
	UnlockAtomeNomLabel.text = str(Molecule.AtomePriceForUnlocking.keys()[0])
	UnlockAtomePrixLabel.text = str(Molecule.AtomePriceForUnlocking.values()[0])
	AtomesBonus.text = Molecule.GetStringNomsSymboles()

func _process(_delta):
	NomLabel.text = tr(Molecule.Name)
	
	if UnlockPanel.visible:
		if Molecule.IsUnlocked:
			UnlockPanel.visible = false
		
		if RessourceManager.DarkMatter.isLessThan(Molecule.AtomePriceForUnlocking.values()[0]):
			UnlockButton.disabled = true
		else:
			UnlockButton.disabled = false
	else:
		QuantityLabel.text = str(RessourceManager.QuantiteesMolecules[Molecule.Name])
		var coin = BonusManager.GetMoleculeBonus("Hydrogene")
		BonusLabel.text = "+" + str(Big.multiply(BonusManager.GetMoleculeBonus("Hydrogene"), Big.new(1.0, 2))) + "%"
	
	
	if not Molecule.IsUnlocked:
		UnlockPanel.visible = true
		return


#Déverrouille la recherche de beryllium
func _on_molecule_unlock_button_pressed():
	print("Bouton Unlock molecule :" + Molecule.Name)
	if Molecule.IsUnlocked:
		return
	
	if RessourceManager.DarkMatter.isLessThan(Molecule.AtomePriceForUnlocking.values()[0]):
		return
			
	RessourceManager.DarkMatter = Big.subtractAbove0(RessourceManager.DarkMatter, Molecule.AtomePriceForUnlocking.values()[0])
		
	Molecule.IsUnlocked = true
	
	#BonusManager.MajBonusMolecules()
