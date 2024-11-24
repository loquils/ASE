extends Control

var UnlockingObject

@onready var TitreLabel = $MainPanelC/DescriptionPanelC/MarginC/VBoxC/TitrePanelC/TitreMarginC/TitreLabel
@onready var PrixLabel = $MainPanelC/DescriptionPanelC/MarginC/VBoxC/PrixPanelC/PrixHBoxC/PrixMarginC/PrixLabel
@onready var UnlockButton = $MainPanelC/DescriptionPanelC/MarginC/VBoxC/ButtonMarginCer/UnlockButton


#Set l'object a unlock, ça peut être un atome, une upgrade etc ...
func _set_objects(unlockingObject):
	UnlockingObject = unlockingObject


#Faut mettre à jour le text
func _process(_delta):
	if UnlockingObject.UnlockingClass != null:
		PrixLabel.text = UnlockingObject.UnlockingClass.ToNamesAndPricesString()
		UnlockButton.disabled = not AreAllRessourcesUnlockingAvailable()
		var titre = tr("DEVEROUILLAGE") + " "
		if UnlockingObject is Atome:
			titre += tr(UnlockingObject.Name)
		else:
			titre += tr("AMELIORATION")
		TitreLabel.text = titre


#Permet de savoir si toutes les ressources sont disponnibles pour unlock un élément.
func AreAllRessourcesUnlockingAvailable():
	for nomUnlock in UnlockingObject.UnlockingClass.PriceForUnlocking:
		match nomUnlock:
			"Coins": 
				if RessourceManager.Coins.isLessThan(UnlockingObject.UnlockingClass.PriceForUnlocking[nomUnlock]):
					return false
			"DarkMatter": 
				if RessourceManager.DarkMatter.isLessThan(UnlockingObject.UnlockingClass.PriceForUnlocking[nomUnlock]):
					return false
			_:
				if RessourceManager.QuantiteesAtomes.has(nomUnlock):
					if RessourceManager.QuantiteesAtomes[nomUnlock].isLessThan(UnlockingObject.UnlockingClass.PriceForUnlocking[nomUnlock]):
						return false
				else:
					return false
	#Si toutes les ressources sont disponibles, on arrive ici :)
	return true

#Permet de Unlock l'objet attribuer au panel unlock en fonction de ce qu'il coute
func OnUnlockButtonPressed():
	print("Bouton achat GENERAL :" + UnlockingObject.Name)
	if UnlockingObject.IsUnlocked:
		return
	
	for priceObjectName in UnlockingObject.UnlockingClass.PriceForUnlocking:
		match priceObjectName:
				"Coins": 
					if RessourceManager.Coins.isLessThan(UnlockingObject.UnlockingClass.PriceForUnlocking[priceObjectName]):
						return
				"DarkMatter": 
					if RessourceManager.DarkMatter.isLessThan(UnlockingObject.UnlockingClass.PriceForUnlocking[priceObjectName]):
						return
				_:
					if RessourceManager.QuantiteesAtomes[priceObjectName].isLessThan(UnlockingObject.UnlockingClass.PriceForUnlocking[priceObjectName]):
						return
	
	for priceObjectName in UnlockingObject.UnlockingClass.PriceForUnlocking:
		match priceObjectName:
			"Coins": 
				RessourceManager.Coins = Big.subtractAbove0(RessourceManager.Coins, UnlockingObject.UnlockingClass.PriceForUnlocking[priceObjectName])
			"DarkMatter": 
				RessourceManager.DarkMatter = Big.subtractAbove0(RessourceManager.DarkMatter, UnlockingObject.UnlockingClass.PriceForUnlocking[priceObjectName])
			_:
				RessourceManager.QuantiteesAtomes[priceObjectName] = Big.subtractAbove0(RessourceManager.QuantiteesAtomes[priceObjectName], UnlockingObject.UnlockingClass.PriceForUnlocking[priceObjectName])
	
	UnlockingObject.IsUnlocked = true
	
	BonusManager.MajObject(UnlockingObject)
