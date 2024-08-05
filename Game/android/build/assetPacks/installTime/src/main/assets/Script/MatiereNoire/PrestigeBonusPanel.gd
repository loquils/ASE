extends Panel

@onready var RecherchesAcheteesLabel = $PrestigeBonusScrollC/ListeVBoxC/RecherchesAcheteesMarginC/BonusRecherchesRecapPanel/BonusEtQuantiteHBoxC/FondBonusQuantPanel/BonusLabel
@onready var RecherchesMatiereNoireAcheteesLabel = $PrestigeBonusScrollC/ListeVBoxC/RecherchesMatiereNoireAcheteesMarginC/BonusRecherchesRecapPanel/BonusEtQuantiteHBoxC/FondBonusQuantPanel/BonusLabel
@onready var BonusLabel1 = $PrestigeBonusScrollC/ListeVBoxC/Bonus1MarginC/BonusRecherchesRecapPanel/BonusEtQuantiteHBoxC/FondBonusQuantPanel/BonusLabel
@onready var BonusLabel2 = $PrestigeBonusScrollC/ListeVBoxC/Bonus2MarginC/BonusRecherchesRecapPanel/BonusEtQuantiteHBoxC/FondBonusQuantPanel/BonusLabel
@onready var BonusLabel3 = $PrestigeBonusScrollC/ListeVBoxC/Bonus3MarginC/BonusRecherchesRecapPanel/BonusEtQuantiteHBoxC/FondBonusQuantPanel/BonusLabel

func _process(delta):
	if visible:
		RecherchesAcheteesLabel.text = str(InfosPartie.RecherchesAchetees)
		RecherchesMatiereNoireAcheteesLabel.text = str(InfosPartie.RecherchesMatiereNoireAchetees)

		BonusLabel1.text = "+" + str(Big.multiply(BonusManager.GetDarkMaterMultiplicator("Hydrogene"), Big.new(1.0, 2))) + "%"
		BonusLabel2.text = "/ " + str(BonusManager.GetDarkMaterDiviseur("Hydrogene"))
		BonusLabel3.text = "+" + str(Big.multiply(BonusManager.GetDarkMaterMultiplicator("HeliumOutputMultiply"), Big.new(1.0, 2))) + "%"
