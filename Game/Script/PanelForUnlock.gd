extends Control

var UnlockingObject

@onready var UnlockButton = $Panel/FondPanel/VBoxC/UnlockButton
@onready var UnlockPanelAtomeLabel = $Panel/FondPanel/VBoxC/AtomeLabel
@onready var UnlockPanelPrixLabel = $Panel/FondPanel/VBoxC/PrixLabel


#Set l'object a unlock, ça peut être un atome, une upgrade etc ...
#Connect le button à la méthode unlock correspondante
func _set_objects(unlockingObject, callable_func_unlock_button_pressed):
	UnlockingObject = unlockingObject
	UnlockButton.connect("pressed", callable_func_unlock_button_pressed)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if UnlockingObject.UnlockingClass != null:
		for nomUnlock in UnlockingObject.UnlockingClass.PriceForUnlocking:
			UnlockPanelAtomeLabel.text = tr(nomUnlock)
			UnlockPanelPrixLabel.text = str(UnlockingObject.UnlockingClass.PriceForUnlocking[nomUnlock])

