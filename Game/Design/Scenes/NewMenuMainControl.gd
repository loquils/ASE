extends Control 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_menu_atome_pressed():
	if $MenuPresentationVBoxC/AllMenus/MenuAtomes.visible:
		$MenuPresentationVBoxC/AllMenus/MenuAtomes.visible = false
	else:
		hideAllMenus()
		$MenuPresentationVBoxC/AllMenus/MenuAtomes.visible = true

func _on_button_menu_recherche_pressed():
	if $MenuPresentationVBoxC/AllMenus/MenuRecherche.visible:
		$MenuPresentationVBoxC/AllMenus/MenuRecherche.visible = false
	else:
		hideAllMenus()
		$MenuPresentationVBoxC/AllMenus/MenuRecherche.visible = true

func _on_button_menu_amelioration_pressed():
	if $MenuPresentationVBoxC/AllMenus/MenuAmelioration.visible:
		$MenuPresentationVBoxC/AllMenus/MenuAmelioration.visible = false
	else:
		hideAllMenus()
		$MenuPresentationVBoxC/AllMenus/MenuAmelioration.visible = true


func _on_button_menu_prestige_pressed():
	pass
	#if $MenuPresentationVBoxC/AllMenus/MenuAmelioration.visible:
		#$MenuPresentationVBoxC/AllMenus/MenuAmelioration.visible = false
	#else:
		#hideAllMenus()
		#$MenuPresentationVBoxC/AllMenus/MenuAmelioration.visible = true


func hideAllMenus():
	for menu in $MenuPresentationVBoxC/AllMenus.get_children():
		menu.visible = false
