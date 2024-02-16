class_name CustomNumber

var decimal
var expo

func _init(deci, ex):
	decimal = deci
	expo = ex



#Permet d'additionner deux chiffre en notation comme on a
func add(numberToAdd):
	var numMax
	var numMin
	
	#On récupère le nombre min et le max
	if expo > numberToAdd.expo:
		numMax = self
		numMin = numberToAdd
	elif expo < numberToAdd.expo:
		numMax = numberToAdd
		numMin = self
	else:
		if decimal > numberToAdd.decimal:
			numMax = self
			numMin = numberToAdd
		else:
			numMax = numberToAdd
			numMin = self
	
	if numMax.expo - numMin.expo <= 5:
		#On calcul le decimal
		decimal = RoundFloat5Decimal(numMax.decimal + (numMin.decimal / 10 ** (numMax.expo - numMin.expo)))
		expo = numMax.expo
		
		#Si on a plus de 1 chiffre avant la virgule, on re-arrange
		var posDot = str(decimal).find(".")
		if posDot != 1:
			decimal = RoundFloat5Decimal(decimal / (10 ** (posDot - 1)))
			expo += posDot - 1



#Permet de soustraire deux chiffre en notation comme on a
func minus(numberToAdd):
	if expo - numberToAdd.expo <= 5:
		#On calcul le decimal
		decimal = RoundFloat5Decimal(decimal - (numberToAdd.decimal / 10 ** (expo - numberToAdd.expo)))
		
		#Si on a des 0 avant la virgule, il faut les virer
		while str(decimal)[0] == "0":
			decimal = RoundFloat5Decimal(decimal * 10)
			expo -= 1



#Permet d'afficher le nombre sous la forme 1.00e10
#Si on est en dessous du million, affiche le chiffre normalement
func prints():
	if expo < 6:
		print(str(decimal * (10**expo)))
	else:
		print(str(decimal) + "e" + str(expo)) #Debug
		#print(str(decimal).substr(0, 4) + "e" + str(expo))



#Permet de couper le chiffre à la 5eme décimale
func RoundFloat5Decimal(number):
	return float(str(number).substr(0, 7))
