extends Control

@onready var MessageLabel = $MessageMarginC/VBoxC/MessageMarginC/MessageLabel
@onready var FullPanel = $FullPanel

var NombreFenetres = 8
var IdFenetreActuelle = 0

var AfterAccueil = false
var TutorielEnCours = false

var NomPanelFondTutoControl = "TestControl"

#Permet de commencer le tutoriel
#On pourrait gérer un vrai tutoriel avec un texte quand on débloque certain trucs
#Il nous faudrait juste un process ici, qui vérifie un array de requirements (QuantiteeHydrogene = 500, Quantitée Helium = 1 etc) 
func _process(delta):
	if not RessourceManager.IsTutorialCompleted:
		if not TutorielEnCours:
			if AfterAccueil:
				TutorielEnCours = true
				MessageLabel.text = "MESSAGETUTORIEL0"
				show()


func _on_validation_button_pressed():
	if IdFenetreActuelle < NombreFenetres - 1:
		IdFenetreActuelle += 1
		MessageLabel.text = tr("MESSAGETUTORIEL" + str(IdFenetreActuelle))
		if has_node(NomPanelFondTutoControl + str(IdFenetreActuelle)):
			if has_node(NomPanelFondTutoControl + str(IdFenetreActuelle - 1)):
				get_node(NomPanelFondTutoControl + str(IdFenetreActuelle - 1)).hide()
			else:
				FullPanel.hide()
			get_node(NomPanelFondTutoControl + str(IdFenetreActuelle)).show()
		else:
			if has_node(NomPanelFondTutoControl + str(IdFenetreActuelle - 1)):
				get_node(NomPanelFondTutoControl + str(IdFenetreActuelle - 1)).hide()
			FullPanel.show()
	else:
		RessourceManager.IsTutorialCompleted = true
		hide()
