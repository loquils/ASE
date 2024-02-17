class_name CustomNumber

var decimal
var expo

func _init(deci:float = 0.0, ex:int = 0):
	decimal = deci
	expo = ex


#Permet d'additionner deux chiffre en notation comme on a
func add(numberToAdd:CustomNumber):
	var numMax
	var numMin
	var newDecimal
	var newExpo
	
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
	
	newExpo = numMax.expo
	newDecimal = numMax.decimal
	
	if numMax.expo - numMin.expo <= 5:
		#On calcul le decimal
		newDecimal = RoundFloat5Decimal(numMax.decimal + (numMin.decimal / 10 ** (numMax.expo - numMin.expo)))
		
		#Si on a plus de 1 chiffre avant la virgule, on re-arrange
		var posDot = str(newDecimal).find(".")
		if posDot >= 1:
			newDecimal = RoundFloat5Decimal(newDecimal / (10 ** (posDot - 1)))
			newExpo += posDot - 1
	return CustomNumber.new(newDecimal, newExpo)


#Permet de soustraire deux chiffre en notation comme on a
func minus(numberToMinus:CustomNumber):
	var newDecimal = decimal
	var newExpo = expo
	if expo - numberToMinus.expo <= 5:
		#On calcul le decimal
		newDecimal = RoundFloat5Decimal(decimal - (numberToMinus.decimal / 10 ** (expo - numberToMinus.expo)))
		
		#Si on a des 0 avant la virgule, il faut les virer
		while str(newDecimal)[0] == "0":
			newDecimal = RoundFloat5Decimal(newDecimal * 10)
			newExpo -= 1
			
	return CustomNumber.new(newDecimal, newExpo)


#Permet de multiplier deux CustomNumber
func multiply(numberMultiply:CustomNumber):
	var newDeci = decimal * numberMultiply.decimal
	var newExpo = expo + numberMultiply.expo
	
	#Si on a plus de 1 chiffre avant la virgule, on re-arrange
	var posDot = str(newDeci).find(".")
	if posDot >= 1:
		newDeci = RoundFloat5Decimal(newDeci / (10 ** (posDot - 1)))
		newExpo += posDot - 1
		
	return CustomNumber.new(newDeci, newExpo)


func power(numberPower:CustomNumber):
	if self.compare(numberPower) == 0:
		return CustomNumber.new(1.0)
	
	var newDeci = pow(decimal, numberPower.decimal)
	var newExpo = expo * numberPower.expo
	
	#Si on a plus de 1 chiffre avant la virgule, on re-arrange
	var posDot = str(newDeci).find(".")
	if posDot >= 1:
		newDeci = RoundFloat5Decimal(newDeci / (10 ** (posDot - 1)))
		newExpo += posDot - 1
		
	return CustomNumber.new(newDeci, newExpo)


func compare(numberToCompare:CustomNumber):
	if expo > numberToCompare.expo:
		return 1
	elif expo < numberToCompare.expo:
		return -1
	else:
		if decimal > numberToCompare.decimal:
			return 1
		elif decimal < numberToCompare.decimal:
			return -1
		else:
			return 0


#Permet d'afficher le nombre sous la forme 1.00e10
#Si on est en dessous du million, affiche le chiffre normalement
func prints():
	if expo < 6:
		print(str(decimal * (10**expo)))
	else:
		print(str(decimal) + "e" + str(expo)) #Debug
		#print(str(decimal).substr(0, 4) + "e" + str(expo))


func _to_string():
	if expo < 6:
		return str(decimal * (10**expo))
	else:
		return str(decimal).substr(0, 4) + "e" + str(expo)

#Permet de couper le chiffre à la 5eme décimale
func RoundFloat5Decimal(number):
	return float(str(number).substr(0, 7))
