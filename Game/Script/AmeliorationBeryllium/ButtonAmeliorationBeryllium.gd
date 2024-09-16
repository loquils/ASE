extends Button

var AmeliorationBeryllium: AmeliorationBeryllium

@onready var NomAmeliorationLabel = $MainMarginC/PresVBoxC/NomLabel
@onready var DescriptionAmeliorationLabel = $MainMarginC/PresVBoxC/DescriptionMarginC/DescriptionLabel

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


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(RechercheClick.AmeliorationBerylliumButtonEventTrigger.bind(AmeliorationBeryllium))
	UnlockAtomeNomLabel.text = str(AmeliorationBeryllium.AtomePriceForUnlocking.keys()[0])
	UnlockAtomePrixLabel.text = str(AmeliorationBeryllium.AtomePriceForUnlocking.values()[0])


func _set_var(ameliorationBeryllium:AmeliorationBeryllium):
	AmeliorationBeryllium = ameliorationBeryllium


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	NomAmeliorationLabel.text = tr(AmeliorationBeryllium.Name)
	#DescriptionAmeliorationLabel.text = tr(AmeliorationBeryllium.Description)
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
		
		BonusHydrogeneLabel.text = str(finalLevels[0])
		BonusHeliumLabel.text = str(finalLevels[1])
		BonusLithiumLabel.text = str(finalLevels[2])
		BonusBerylliumLabel.text = str(finalLevels[3])
		
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
