class_name Unlocking

var PriceForUnlocking = {}
var IsDisponible = true

func _init(priceForUnlocking):
	PriceForUnlocking = priceForUnlocking

#Permet de set la disponnibilité de cet éléménent a false.
func SetNonDisponnible():
	IsDisponible = false


#Permet d'écrire en string les noms et la quantitée de ressources nécéssaires pour déverouiller l'élément.
func ToNamesAndPricesString():
	var coin = ""
	for price in PriceForUnlocking:
		coin += tr(price) + " : " + str(PriceForUnlocking[price])
		if not PriceForUnlocking.keys().back() == price:
			coin += "\n"
	return coin
