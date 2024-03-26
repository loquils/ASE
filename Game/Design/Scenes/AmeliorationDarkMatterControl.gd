extends Control

var AmeliorationDarkMatter = preload("res://Design/Scenes/ButtonDarkMatter.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for ameliorationDarkMatterInList in RessourceManager.ListeAmeliorationsDarkMatter:
		var newButtonAmeliorationDarkMatter = AmeliorationDarkMatter.instantiate()
		newButtonAmeliorationDarkMatter._set_var(ameliorationDarkMatterInList)
		$PresentationVBoxC/MarginC/VBoxC/PrestigeAmeliorationScrollC/PrestigeGridC.add_child(newButtonAmeliorationDarkMatter)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		$PresentationVBoxC/MarginC/VBoxC/Label.text = str(GetDeltaDarkMatter())


#Pour l'instant on utilise ça, c'est pas bien :3
func GetDeltaDarkMatter():
	if RessourceManager.HydrogeneMax.isLessThan(Big.new(1.0,5)):
		return Big.new(0.0)
		
	return Big.power(Big.subtractAbove0(RessourceManager.HydrogeneMax, Big.new(1.0,5)), 0.25)


func _on_button_exit_pressed():
	hide()


func _on_prestige_button_pressed():
	#Faut tout reset, Et ajouter la money :)
	RessourceManager.DarkMatter = Big.add(RessourceManager.DarkMatter, GetDeltaDarkMatter())
