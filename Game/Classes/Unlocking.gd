class_name Unlocking

var PriceForUnlocking = {}

func _init(priceForUnlocking):
	PriceForUnlocking = priceForUnlocking


#Permet d'écrire en string les noms et la quantitée de ressources nécéssaires pour déverouiller l'élément.
func ToNamesAndPricesString():
	var coin = ""
	for price in PriceForUnlocking:
		coin += tr(price) + " : " + str(PriceForUnlocking[price])
		if not PriceForUnlocking.keys().back() == price:
			coin += "\n"
	return coin
