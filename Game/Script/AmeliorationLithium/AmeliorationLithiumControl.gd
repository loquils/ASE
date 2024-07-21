extends Control

@onready var NoyauSprite2D = $Node2DLithium/NoyauSprite2D
@onready var AmeliorationNoyauMenu = $PresentationVBoxC/MenuNoyauMarginC
@onready var AmeliorationElectronMenu = $PresentationVBoxC/MenuElectronMarginC
@onready var ListeAmeliorationsNoyau = $PresentationVBoxC/MenuNoyauMarginC/AmeliorationsNoyauVBoxC/AmeliorationsNoyauxHBoxC
@onready var ListeAmeliorationsElectronK = $PresentationVBoxC/MenuElectronMarginC/AmeliorationsElectronsVBoxC/ElectronsKMarginC/FondPanel/PresVBoxC/AmeliorationsElectronsKHBoxC
@onready var ListeAmeliorationsElectronL = $PresentationVBoxC/MenuElectronMarginC/AmeliorationsElectronsVBoxC/ElectronsLMarginC/FondPanel/PresVBoxC/AmeliorationsElectronsLHBoxC

var CustomCanvasAmeliorationNoyauLithium = preload("res://Design/Scenes/Ameliorations/CanvasAmelioLithiumNoyau.tscn")
var CustomButtonAmeliorationElectronLithium = preload("res://Design/Scenes/Ameliorations/ButtonAmeliorationLithium.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	RechercheClick.connect("AmeliorationLithium_button_pressed", AchatAmeliorationLithiumButtonPressed)
	
	for ameliorationLithium in RessourceManager.ListeAmeliorationsLithium:
		match ameliorationLithium.CategorieAmeliorationLithium:
			AmeliorationLithium.CategorieAmeliorationLithiumEnum.Proton:
				var newAmeliorationLithiumCanvas = CustomCanvasAmeliorationNoyauLithium.instantiate()
				newAmeliorationLithiumCanvas._set_var(ameliorationLithium)
				ListeAmeliorationsNoyau.add_child(newAmeliorationLithiumCanvas)
			AmeliorationLithium.CategorieAmeliorationLithiumEnum.Neutron:
				var newAmeliorationLithiumCanvas = CustomCanvasAmeliorationNoyauLithium.instantiate()
				newAmeliorationLithiumCanvas._set_var(ameliorationLithium)
				ListeAmeliorationsNoyau.add_child(newAmeliorationLithiumCanvas)
			AmeliorationLithium.CategorieAmeliorationLithiumEnum.ElectronK:
				var newAmeliorationElectronLithiumButton = CustomButtonAmeliorationElectronLithium.instantiate()
				newAmeliorationElectronLithiumButton._set_var(ameliorationLithium)
				ListeAmeliorationsElectronK.add_child(newAmeliorationElectronLithiumButton)
			AmeliorationLithium.CategorieAmeliorationLithiumEnum.ElectronL:
				var newAmeliorationElectronLithiumButton = CustomButtonAmeliorationElectronLithium.instantiate()
				newAmeliorationElectronLithiumButton._set_var(ameliorationLithium)
				ListeAmeliorationsElectronL.add_child(newAmeliorationElectronLithiumButton)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("2D_mouse_click") and visible and NoyauSprite2D.get_rect().has_point(NoyauSprite2D.to_local(get_global_mouse_position()))):
		if (not AmeliorationNoyauMenu.visible):
			AmeliorationNoyauMenu.show()
			
			if (AmeliorationElectronMenu.visible):
				AmeliorationElectronMenu.hide()
			else:
				$Node2DLithium.position -= Vector2(0,100)
		else:
			AmeliorationNoyauMenu.hide()
			$Node2DLithium.position += Vector2(0,100)
	
	elif (Input.is_action_just_pressed("2D_mouse_click") and visible and not AmeliorationElectronMenu.visible and get_local_mouse_position().y < size.y - AmeliorationNoyauMenu.size.y):
		if (not AmeliorationElectronMenu.visible):
			AmeliorationElectronMenu.show()
			
			if (AmeliorationNoyauMenu.visible):
				AmeliorationNoyauMenu.hide()
			else:
				$Node2DLithium.position -= Vector2(0,100)
		else:
			AmeliorationElectronMenu.hide()
			$Node2DLithium.position += Vector2(0,100)


#Trigger lors de l'appuie sur un bouton pour augmenter une amélioration de lithium
func AchatAmeliorationLithiumButtonPressed(ameliorationLithium:AmeliorationLithium):
	if ameliorationLithium.GetPrixAmeliorationLithium().isLessThanOrEqualTo(RessourceManager.QuantiteesAtomes["Lithium"]):
		RessourceManager.QuantiteesAtomes["Lithium"] = Big.subtractAbove0(RessourceManager.QuantiteesAtomes["Lithium"], ameliorationLithium.GetPrixAmeliorationLithium())
		ameliorationLithium.Level = Big.add(ameliorationLithium.Level, Big.new(1.0))
		BonusManager.MajBonusAmeliorationLithium()


#Trigger lors de l'appuie sur le bouton exit
func _on_button_exit_pressed():
	AmeliorationNoyauMenu.hide()
	hide()


#Trigger lors de l'appuie sur le bouton close du menu d'améliorations du noyau
func _on_button_noyau_close_pressed():
	AmeliorationNoyauMenu.hide()
	$Node2DLithium.position += Vector2(0,100)


#Trigger lors de l'appuie sur le bouton close du menu d'améliorations
func _on_button_electron_close_pressed():
	AmeliorationElectronMenu.hide()
	$Node2DLithium.position += Vector2(0,100)
