extends Control

var UnlockingObject

@onready var UnlockButton = $Panel/FondPanel/VBoxC/UnlockButton
@onready var UnlockPanelAtomeLabel = $Panel/FondPanel/VBoxC/AtomeLabel
@onready var UnlockPanelPrixLabel = $Panel/FondPanel/VBoxC/PrixLabel


#Set l'object a unlock, ça peut être un atome, une upgrade etc ...
func _set_objects(unlockingObject):
	UnlockingObject = unlockingObject


#Faut mettre à jour le text
func _process(_delta):
	if UnlockingObject.UnlockingClass != null:
		#TODO: Il faut faire en sorte que s'il y a plusieurs élément pour unlock bah ça les prennent en compte xD
		for nomUnlock in UnlockingObject.UnlockingClass.PriceForUnlocking:
			UnlockPanelAtomeLabel.text = tr(nomUnlock)
			UnlockPanelPrixLabel.text = str(UnlockingObject.UnlockingClass.PriceForUnlocking[nomUnlock])
			match nomUnlock:
				"Coins": 
					UnlockButton.disabled = RessourceManager.Coins.isLessThan(UnlockingObject.UnlockingClass.PriceForUnlocking[nomUnlock])
				"DarkMatter": 
					UnlockButton.disabled = RessourceManager.DarkMatter.isLessThan(UnlockingObject.UnlockingClass.PriceForUnlocking[nomUnlock])
				_:
					if RessourceManager.QuantiteesAtomes.has(nomUnlock):
						UnlockButton.disabled = RessourceManager.QuantiteesAtomes[nomUnlock].isLessThan(UnlockingObject.UnlockingClass.PriceForUnlocking[nomUnlock])
					else:
						UnlockButton.disabled = true


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
