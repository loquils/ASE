extends Button

var AmeliorationBeryllium: AmeliorationBeryllium

@onready var NomAmeliorationLabel = $MainMarginC/PresVBoxC/NomLabel

@onready var BonusHydrogeneLabel = $MainMarginC/PresVBoxC/DetailsMarginC/VBoxC/HBoxC/HydrogeneFondPanel/MarginC/VBoxC/BonusLabel
@onready var BonusHeliumLabel = $MainMarginC/PresVBoxC/DetailsMarginC/VBoxC/HBoxC/HeliumFondPanel/MarginC/VBoxC/BonusLabel
@onready var BonusLithiumLabel = $MainMarginC/PresVBoxC/DetailsMarginC/VBoxC/HBoxC2/LithiumFondPanel/MarginC/VBoxC/BonusLabel
@onready var BonusBerylliumLabel = $MainMarginC/PresVBoxC/DetailsMarginC/VBoxC/HBoxC2/BerylliumFondPanel/MarginC/VBoxC/BonusLabel

@onready var NiveauLabel = $MainMarginC/PresVBoxC/PrixNiveauMarginC/HBoxC/NiveauLabel
@onready var PrixLabel = $MainMarginC/PresVBoxC/PrixNiveauMarginC/HBoxC/VBoxC/PrixLabel

@onready var UnlockPanel = $PanelForUnlock
@onready var UnlockAtomeNomLabel = $PanelForUnlock/FondPanel/VBoxContainer/AtomeLabel
@onready var UnlockAtomePrixLabel = $PanelForUnlock/FondPanel/VBoxContainer/PrixLabel
@onready var AmeliorationBerylliumUnlockButton= $PanelForUnlock/FondPanel/VBoxContainer/AmeliorationBerylliumUnlockButton

@onready var AllAmeliorationsVBoxC = $MainMarginC/PresVBoxC/DetailsMarginC/VBoxC
@onready var BerylliumAmeliorationVBoxC = $MainMarginC/PresVBoxC/DetailsMarginC/BerylliumVBoxC
@onready var BerylliumCurrentHydrogenBonusLabel = $MainMarginC/PresVBoxC/DetailsMarginC/BerylliumVBoxC/HBoxC/HydrogeneFondPanel/MarginC/VBoxC/VBoxC/BonusActuelLabel
@onready var BerylliumNextHydrogenBonusLabel = $MainMarginC/PresVBoxC/DetailsMarginC/BerylliumVBoxC/HBoxC/HydrogeneFondPanel/MarginC/VBoxC/VBoxC/BonusSuivantLabel
@onready var BerylliumCurrentHeliumBonusLabel = $MainMarginC/PresVBoxC/DetailsMarginC/BerylliumVBoxC/HBoxC/HeliumFondPanel/MarginC/VBoxC/VBoxC/BonusActuelLabel
@onready var BerylliumNextHeliumBonusLabel = $MainMarginC/PresVBoxC/DetailsMarginC/BerylliumVBoxC/HBoxC/HeliumFondPanel/MarginC/VBoxC/VBoxC/BonusSuivantLabel
@onready var BerylliumCurrentLithiumBonusLabel = $MainMarginC/PresVBoxC/DetailsMarginC/BerylliumVBoxC/HBoxC2/LithiumFondPanel/MarginC/VBoxC/VBoxC/BonusActuelLabel
@onready var BerylliumNextLithiumBonusLabel = $MainMarginC/PresVBoxC/DetailsMarginC/BerylliumVBoxC/HBoxC2/LithiumFondPanel/MarginC/VBoxC/VBoxC/BonusSuivantLabel
@onready var BerylliumCurrentBerylliumBonusLabel = $MainMarginC/PresVBoxC/DetailsMarginC/BerylliumVBoxC/HBoxC2/BerylliumFondPanel/MarginC/VBoxC/VBoxC/BonusActuelLabel
@onready var BerylliumNextBerylliumBonusLabel = $MainMarginC/PresVBoxC/DetailsMarginC/BerylliumVBoxC/HBoxC2/BerylliumFondPanel/MarginC/VBoxC/VBoxC/BonusSuivantLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(RechercheClick.AmeliorationBerylliumButtonEventTrigger.bind(AmeliorationBeryllium))
	UnlockAtomeNomLabel.text = str(AmeliorationBeryllium.AtomePriceForUnlocking.keys()[0])
	UnlockAtomePrixLabel.text = str(AmeliorationBeryllium.AtomePriceForUnlocking.values()[0])


func _set_var(ameliorationBeryllium:AmeliorationBeryllium):
	AmeliorationBeryllium = ameliorationBeryllium


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	NomAmeliorationLabel.text = tr(AmeliorationBeryllium.Name)
	if UnlockPanel.visible:
		if AmeliorationBeryllium.IsUnlocked:
			UnlockPanel.visible = false
		
		if RessourceManager.QuantiteesAtomes[AmeliorationBeryllium.AtomePriceForUnlocking.keys()[0]].isLessThan(AmeliorationBeryllium.AtomePriceForUnlocking.values()[0]):
			AmeliorationBerylliumUnlockButton.disabled = true
		else:
			AmeliorationBerylliumUnlockButton.disabled = false
	
	if AmeliorationBeryllium.IsUnlocked:
		var bonusesAmelioration = AmeliorationBeryllium.BonusesAmeliorationBeryllium
		var bonusesAdd = BonusManager.GetAmeliorationBerylliumNumberAddBonuses()
		var finalLevels = [0, 0, 0, 0]
		
		for i in range(0,4):
			finalLevels[i] = Big.add(bonusesAmelioration[i], bonusesAdd[i])
			
		if AmeliorationBeryllium.Id != 3:
			if BerylliumAmeliorationVBoxC.visible:
				BerylliumAmeliorationVBoxC.hide()
			if not AllAmeliorationsVBoxC.visible:
				AllAmeliorationsVBoxC.show()
			
			BonusHydrogeneLabel.text = str(finalLevels[0])
			BonusHeliumLabel.text = str(finalLevels[1])
			BonusLithiumLabel.text = str(finalLevels[2])
			BonusBerylliumLabel.text = str(finalLevels[3])

		else:
			if not BerylliumAmeliorationVBoxC.visible:
				BerylliumAmeliorationVBoxC.show()
			if AllAmeliorationsVBoxC.visible:
				AllAmeliorationsVBoxC.hide()
			
			BerylliumCurrentHydrogenBonusLabel.text = "+" + str(bonusesAdd[0])
			BerylliumNextHydrogenBonusLabel.text = "+" + str(Big.add(Big.new(bonusesAdd[0]), bonusesAmelioration[0]))
			BerylliumCurrentHeliumBonusLabel.text = "+" + str(bonusesAdd[1])
			BerylliumNextHeliumBonusLabel.text = "+" + str(Big.add(Big.new(bonusesAdd[1]), bonusesAmelioration[1]))
			BerylliumCurrentLithiumBonusLabel.text = "+" + str(bonusesAdd[2])
			BerylliumNextLithiumBonusLabel.text = "+" + str(Big.add(Big.new(bonusesAdd[2]), bonusesAmelioration[2]))
			BerylliumCurrentBerylliumBonusLabel.text = "+" + str(bonusesAdd[3])
			BerylliumNextBerylliumBonusLabel.text = "+" + str(Big.add(Big.new(bonusesAdd[3]), bonusesAmelioration[3]))
			
		NiveauLabel.text = tr("Niv.") + str(AmeliorationBeryllium.Level)
		var prix = AmeliorationBeryllium.GetPrixAmeliorationBeryllium()
		PrixLabel.text = tr(prix.keys()[0])  + ": " + str(prix.values()[0])
	else:
		UnlockPanel.visible = true
		return
	
	if AmeliorationBeryllium.IsUnlocked:
		var prixAmelioration = AmeliorationBeryllium.GetPrixAmeliorationBeryllium()
		var atomPrix = prixAmelioration.keys()[0]
		var quantiteePrix = prixAmelioration.values()[0]
		if RessourceManager.QuantiteesAtomes.has(atomPrix):
			if RessourceManager.QuantiteesAtomes[atomPrix].isLessThan(quantiteePrix):
				disabled = true
			else : 
				disabled = false


#Déverrouille la recherche de beryllium
func _on_amelioration_beryllium_unlock_button_pressed():
	print("Bouton Unlock beryllium amélioration :" + AmeliorationBeryllium.Name)
	if AmeliorationBeryllium.IsUnlocked:
		return
	
	if RessourceManager.QuantiteesAtomes[AmeliorationBeryllium.AtomePriceForUnlocking.keys()[0]].isLessThan(AmeliorationBeryllium.AtomePriceForUnlocking.values()[0]):
		return
			
	RessourceManager.QuantiteesAtomes[AmeliorationBeryllium.AtomePriceForUnlocking.keys()[0]] = Big.subtractAbove0(RessourceManager.QuantiteesAtomes[AmeliorationBeryllium.AtomePriceForUnlocking.keys()[0]], AmeliorationBeryllium.AtomePriceForUnlocking.values()[0])
		
	AmeliorationBeryllium.IsUnlocked = true
	
	BonusManager.MajBonusAmeliorationBeryllium()
