extends Panel

@onready var BonusLabel1 = $PrestigeBonusScrollC/ListeVBoxC/Bonus1MarginC/BonusRecherchesRecapPanel/BonusEtQuantiteHBoxC/FondBonusQuantPanel/BonusLabel
@onready var BonusLabel2 = $PrestigeBonusScrollC/ListeVBoxC/Bonus2MarginC/BonusRecherchesRecapPanel/BonusEtQuantiteHBoxC/FondBonusQuantPanel/BonusLabel

func _process(delta):
	if visible:
		BonusLabel1.text = "x " + str(BonusManager.CurrentBonusesRecherchesMatiereNoire["HydrogeneCoeffMultiplicateurRapport"])
		BonusLabel2.text = "x " + str(BonusManager.CurrentBonusesRecherchesMatiereNoire["HeliumCoeffMultiplicateurRapport"])
