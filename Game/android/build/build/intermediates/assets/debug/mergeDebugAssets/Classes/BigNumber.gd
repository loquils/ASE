class_name Big
extends RefCounted


## Maximum Big Number Mantissa
const MANTISSA_MAX: float = 1209600.0
## Big Number Mantissa floating-point precision
const MANTISSA_PRECISION: float = 0.0000001


## int (signed 64-bit) minimum value
const INT_MIN: int = -9223372036854775808
## int (signed 64-bit) maximum value
const INT_MAX: int = 9223372036854775807


## Big Number Mantissa
var mantissa: float
## Big Number Exponent
var exponent: int


## Various options to control the string presentation of Big Numbers
static var options = {
	"dynamic_decimals": false, 
	"dynamic_numbers": 4, 
	"small_decimals": 3, 
	"thousand_decimals": 1, 
	"big_decimals": 1, 
	"scientific_decimals": 3, 
	"logarithmic_decimals": 4, 
	"thousand_separator": ",", 
	"decimal_separator": ".", 
	"suffix_separator": "", 
	"reading_separator": "", 
	"thousand_name": "thousand"
}



func _init(m: Variant = 1.0, e: int = 0) -> void:
	if m is Big:
		mantissa = m.mantissa
		exponent = m.exponent
	elif typeof(m) == TYPE_STRING:
		var scientific: PackedStringArray = m.split("e")
		mantissa = float(scientific[0])
		exponent = int(scientific[1]) if scientific.size() > 1 else 0
	else:
		if typeof(m) != TYPE_INT and typeof(m) != TYPE_FLOAT:
			printerr("Big Error: Unknown data type passed as a mantissa!")
		mantissa = m
		exponent = e
	Big._sizeCheck(mantissa)
	Big.normalize(self)


## Verifies (or converts) an argument into a Big number
static func _typeCheck(n) -> Big:
	if n is Big:
		return n
	var result := Big.new(n)
	return result


## Warns if Big number's mantissa exceeds max
static func _sizeCheck(m: float) -> void:
	if m > MANTISSA_MAX:
		printerr("Big Error: Mantissa \"" + str(m) + "\" exceeds MANTISSA_MAX. Use exponent or scientific notation")


## [url=https://en.wikipedia.org/wiki/Normalized_number]Normalize[/url] a Big number
static func normalize(big: Big) -> void:
	# Store sign if negative
	var is_negative := false
	if big.mantissa < 0:
		is_negative = true
		big.mantissa *= -1
		
	if big.mantissa < 1.0 or big.mantissa >= 10.0:
		var diff: int = floor(log10(big.mantissa))
		if diff > -10 and diff < 248:
			var div = 10 ** diff
			if div > MANTISSA_PRECISION:
				big.mantissa /= div
				big.exponent += diff
	while big.exponent < 0:
		big.mantissa *= 0.1
		big.exponent += 1
	while big.mantissa >= 10.0:
		big.mantissa *= 0.1
		big.exponent += 1
	if big.mantissa == 0:
		big.mantissa = 0.0
		big.exponent = 0
	big.mantissa = snapped(big.mantissa, MANTISSA_PRECISION)
	
	# Return sign if negative
	if (is_negative):
		big.mantissa *= -1


## Returns the absolute value of a number in Big format
static func absolute(x) -> Big:
	var result := Big.new(x)
	result.mantissa = abs(result.mantissa)
	return result


## Adds two numbers and returns the Big number result [br][br]
static func add(x, y) -> Big:
	x = Big._typeCheck(x)
	y = Big._typeCheck(y)
	var result := Big.new(x)
	
	var exp_diff: float = y.exponent - x.exponent
	
	if exp_diff < 248.0:
		var scaled_mantissa: float = y.mantissa * 10 ** exp_diff
		result.mantissa = x.mantissa + scaled_mantissa
	elif x.isLessThan(y): # When difference between values is too big, discard the smaller number
		result.mantissa = y.mantissa 
		result.exponent = y.exponent
	Big.normalize(result)
	return result


## Subtracts two numbers and returns the Big number result
static func subtractT(x, y) -> Big:
	var negated_y := Big.new(-y.mantissa, y.exponent)
	return add(x, negated_y)



## Multiplies two numbers and returns the Big number result
static func multiply(x, y) -> Big:
	x = Big._typeCheck(x)
	y = Big._typeCheck(y)
	var result := Big.new()
	
	var new_exponent: int = y.exponent + x.exponent
	var new_mantissa: float = y.mantissa * x.mantissa
	while new_mantissa >= 10.0:
		new_mantissa /= 10.0
		new_exponent += 1
	result.mantissa = new_mantissa
	result.exponent = new_exponent
	Big.normalize(result)
	return result


## Divides two numbers and returns the Big number result
static func divide(x, y) -> Big:
	x = Big._typeCheck(x)
	y = Big._typeCheck(y)
	var result := Big.new(x)
	
	if y.mantissa > -MANTISSA_PRECISION and y.mantissa < MANTISSA_PRECISION:
		printerr("Big Error: Divide by zero or less than " + str(MANTISSA_PRECISION))
		return x
	var new_exponent = x.exponent - y.exponent
	var new_mantissa = x.mantissa / y.mantissa
	while new_mantissa > 0.0 and new_mantissa < 1.0:
		new_mantissa *= 10.0
		new_exponent -= 1
	result.mantissa = new_mantissa
	result.exponent = new_exponent
	Big.normalize(result)
	return result


## Raises a Big number to the nth power and returns the Big number result
static func power(x: Big, y) -> Big:
	if(typeof(y) == typeof(Big)):
		y = y.mantissa * (10**y.exponent)
		
	var result := Big.new(x)
	if typeof(y) == TYPE_INT:
		if y <= 0:
			if y < 0:
				printerr("Big Error: Negative exponents are not supported!")
			result.mantissa = 1.0
			result.exponent = 0
			return result
		
		var y_mantissa: float = 1.0
		var y_exponent: int = 0
		
		while y > 1:
			Big.normalize(result)
			if y % 2 == 0:
				result.exponent *= 2
				result.mantissa **= 2
				y = y / 2
			else:
				y_mantissa = result.mantissa * y_mantissa
				y_exponent = result.exponent + y_exponent
				result.exponent *= 2
				result.mantissa **= 2
				y = (y - 1) / 2
		
		result.exponent = y_exponent + result.exponent
		result.mantissa = y_mantissa * result.mantissa
		Big.normalize(result)
		return result
	elif typeof(y) == TYPE_FLOAT:
		if result.mantissa == 0:
			return result
		
		# fast track
		var temp: float = result.exponent * y
		var newMantissa = result.mantissa ** y
		if (round(y) == y
				and temp <= INT_MAX
				and temp >= INT_MIN
				and is_finite(temp)
		):
			if is_finite(newMantissa):
				result.mantissa = newMantissa
				result.exponent = int(temp)
				Big.normalize(result)
				return result
		
		# a bit slower, still supports floats
		var newExponent: int = int(temp)
		var residue: float = temp - newExponent
		newMantissa = 10 ** (y * Big.log10(result.mantissa) + residue)
		if newMantissa != INF and newMantissa != -INF:
			result.mantissa = newMantissa
			result.exponent = newExponent
			Big.normalize(result)
			return result
		
		if round(y) != y:
			printerr("Big Error: Power function does not support large floats, use integers!")
		
		return power(x, int(y))
	else:
		printerr("Big Error: Unknown/unsupported data type passed as an exponent in power function!")
		return x


## Square Roots a given Big number and returns the Big number result
static func root(x: Big) -> Big:
	var result := Big.new(x)
	
	if result.exponent % 2 == 0:
		result.mantissa = sqrt(result.mantissa)
		@warning_ignore("integer_division")
		result.exponent = result.exponent / 2
	else:
		result.mantissa = sqrt(result.mantissa * 10)
		@warning_ignore("integer_division")
		result.exponent = (result.exponent - 1) / 2
	Big.normalize(result)
	return result


## Modulos a number and returns the Big number result
static func modulo(x, y) -> Big:
	var result := Big.new(x.mantissa, x.exponent)
	y = Big._typeCheck(y)
	var big = { "mantissa": x.mantissa, "exponent": x.exponent }
	Big.divide(result, y)
	Big.roundDown(result)
	Big.multiply(result, y)
	Big.subtract(result, big)
	result.mantissa = abs(result.mantissa)
	return result


## Rounds down a Big number
static func roundDown(x: Big) -> Big:
	if x.exponent == 0:
		x.mantissa = floor(x.mantissa)
	else:
		var precision := 1.0
		for i in range(min(8, x.exponent)):
			precision /= 10.0
		if precision < MANTISSA_PRECISION:
			precision = MANTISSA_PRECISION
		x.mantissa = floor(x.mantissa / precision) * precision
	return x


## Equivalent of [code]min(Big, Big)[/code]
static func minValue(m, n) -> Big:
	m = Big._typeCheck(m)
	if m.isLessThan(n):
		return m
	else:
		return n


## Equivalent of [code]max(Big, Big)[/code]
static func maxValue(m, n) -> Big:
	m = Big._typeCheck(m)
	if m.isGreaterThan(n):
		return m
	else:
		return n


## Equivalent of [code]Big + n[/code]
func plus(n) -> Big:
	return Big.add(self, n)


## Equivalent of [code]Big += n[/code]
func plusEquals(n) -> Big:
	var new_value = Big.add(self, n)
	mantissa = new_value.mantissa
	exponent = new_value.exponent
	return self

## Equivalent of [code]Big - n[/code]
func minus(n) -> Big:
	return Big.subtract(self, n)


## Equivalent of [code]Big -= n[/code]
func minusEquals(n) -> Big:
	var new_value: Big = Big.subtract(self, n)
	mantissa = new_value.mantissa
	exponent = new_value.exponent
	return self


## Equivalent of [code]Big * n[/code]
func times(n) -> Big:
	return Big.multiply(self, n)


## Equivalent of [code]Big *= n[/code]
func timesEquals(n) -> Big:
	var new_value: Big = Big.multiply(self, n)
	mantissa = new_value.mantissa
	exponent = new_value.exponent
	return self


## Equivalent of [code]Big / n[/code]
func dividedBy(n) -> Big:
	return Big.divide(self, n)


## Equivalent of [code]Big /= n[/code]
func dividedByEquals(n) -> Big:
	var new_value: Big = Big.divide(self, n)
	mantissa = new_value.mantissa
	exponent = new_value.exponent
	return self


## Equivalent of [code]Big % n[/code]
func mod(n) -> Big:
	return Big.modulo(self, n)


## Equivalent of [code]Big %= n[/code]
func modEquals(n) -> Big:
	var new_value := Big.modulo(self, n)
	mantissa = new_value.mantissa
	exponent = new_value.exponent
	return self


## Equivalent of [code]Big ** n[/code]
func toThePowerOf(n) -> Big:
	return Big.power(self, n)


## Equivalent of [code]Big **= n[/code]
func toThePowerOfEquals(n) -> Big:
	var new_value: Big = Big.power(self, n)
	mantissa = new_value.mantissa
	exponent = new_value.exponent
	return self


## Equivalent of [code]sqrt(Big)[/code]
func squareRoot() -> Big:
	var new_value := Big.root(self)
	mantissa = new_value.mantissa
	exponent = new_value.exponent
	return self


## Equivalent of [code]Big == n[/code]
func isEqualTo(n) -> bool:
	n = Big._typeCheck(n)
	Big.normalize(n)
	return n.exponent == exponent and is_equal_approx(n.mantissa, mantissa)


## Equivalent of [code]Big > n[/code]
func isGreaterThan(n) -> bool:
	return !isLessThanOrEqualTo(n)


## Equivalent of [code]Big >== n[/code]
func isGreaterThanOrEqualTo(n) -> bool:
	return !isLessThan(n)


## Equivalent of [code]Big < n[/code]
func isLessThan(n) -> bool:
	n = Big._typeCheck(n)
	Big.normalize(n)
	if (mantissa == 0
			and (n.mantissa > MANTISSA_PRECISION or mantissa < MANTISSA_PRECISION)
			and n.mantissa == 0
	):
		return false
	if exponent < n.exponent:
		return true
	elif exponent == n.exponent:
		if mantissa < n.mantissa:
			return true
		else:
			return false
	else:
		return false


## Equivalent of [code]Big <= n[/code]
func isLessThanOrEqualTo(n) -> bool:
	n = Big._typeCheck(n)
	Big.normalize(n)
	if isLessThan(n):
		return true
	if n.exponent == exponent and is_equal_approx(n.mantissa, mantissa):
		return true
	return false


static func log10(x) -> float:
	return log(x) * 0.4342944819032518


func absLog10() -> float:
	return exponent + Big.log10(abs(mantissa))


func ln() -> float:
	return 2.302585092994045 * logN(10)


func logN(base) -> float:
	return (2.302585092994046 / log(base)) * (exponent + Big.log10(mantissa))


func pow10(value: int) -> void:
	mantissa = 10 ** (value % 1)
	exponent = int(value)


## Sets the Thousand name option
static func setThousandName(name: String) -> void:
	options.thousand_name = name


## Sets the Thousand Separator option
static func setThousandSeparator(separator: String) -> void:
	options.thousand_separator = separator


## Sets the Decimal Separator option
static func setDecimalSeparator(separator: String) -> void:
	options.decimal_separator = separator


## Sets the Suffix Separator option
static func setSuffixSeparator(separator: String) -> void:
	options.suffix_separator = separator


## Sets the Reading Separator option
static func setReadingSeparator(separator: String) -> void:
	options.reading_separator = separator


## Sets the Dynamic Decimals option
static func setDynamicDecimals(d: bool) -> void:
	options.dynamic_decimals = d


## Sets the Dynamic numbers digits option
static func setDynamicNumbers(d: int) -> void:
	options.dynamic_numbers = d


## Sets the small decimal digits option
static func setSmallDecimals(d: int) -> void:
	options.small_decimals = d


## Sets the thousand decimal digits option
static func setThousandDecimals(d: int) -> void:
	options.thousand_decimals = d


## Sets the big decimal digits option
static func setBigDecimals(d: int) -> void:
	options.big_decimals = d


## Sets the scientific notation decimal digits option
static func setScientificDecimals(d: int) -> void:
	options.scientific_decimals = d


## Sets the logarithmic notation decimal digits option
static func setLogarithmicDecimals(d: int) -> void:
	options.logarithmic_decimals = d


## Converts the Big Number into a string
func toString() -> String:
	var mantissa_decimals := 0
	if str(mantissa).find(".") >= 0:
		mantissa_decimals = str(mantissa).split(".")[1].length()
	if mantissa_decimals > exponent:
		if exponent < 248:
			return str(mantissa * 10 ** exponent)
		else:
			return toPlainScientific()
	else:
		var mantissa_string := str(mantissa).replace(".", "")
		for _i in range(exponent-mantissa_decimals):
			mantissa_string += "0"
		return mantissa_string


## Converts the Big Number into a string (in plain Scientific format)
func toPlainScientific() -> String:
	return str(mantissa) + "e" + str(exponent)


## Converts the Big Number into a string (in Scientific format)
func toScientific(no_decimals_on_small_values = false, force_decimals = false) -> String:
	if exponent < 3:
		var decimal_increments: float = 1 / (10 ** options.scientific_decimals / 10)
		var value := str(snappedf(mantissa * 10 ** exponent, decimal_increments))
		var split := value.split(".")
		if no_decimals_on_small_values:
			return split[0]
		if split.size() > 1:
			for i in range(options.logarithmic_decimals):
				if split[1].length() < options.scientific_decimals:
					split[1] += "0"
			return split[0] + options.decimal_separator + split[1].substr(0,min(options.scientific_decimals, options.dynamic_numbers - split[0].length() if options.dynamic_decimals else options.scientific_decimals))
		else:
			return value
	else:
		var split := str(mantissa).split(".")
		if split.size() == 1:
			split.append("")
		if force_decimals:
			for i in range(options.scientific_decimals):
				if split[1].length() < options.scientific_decimals:
					split[1] += "0"
		return split[0] + options.decimal_separator + split[1].substr(0,min(options.scientific_decimals, options.dynamic_numbers-1 - str(exponent).length() if options.dynamic_decimals else options.scientific_decimals)) + "e" + str(exponent)


## Converts the Big Number into a string (in Logarithmic format)
func toLogarithmic(no_decimals_on_small_values = false) -> String:
	var decimal_increments: float = 1 / (10 ** options.logarithmic_decimals / 10)
	if exponent < 3:
		var value := str(snappedf(mantissa * 10 ** exponent, decimal_increments))
		var split := value.split(".")
		if no_decimals_on_small_values:
			return split[0]
		if split.size() > 1:
			for i in range(options.logarithmic_decimals):
				if split[1].length() < options.logarithmic_decimals:
					split[1] += "0"
			return split[0] + options.decimal_separator + split[1].substr(0,min(options.logarithmic_decimals, options.dynamic_numbers - split[0].length() if options.dynamic_decimals else options.logarithmic_decimals))
		else:
			return value
	var dec := str(snappedf(abs(log(mantissa) / log(10) * 10), decimal_increments))
	dec = dec.replace(".", "")
	for i in range(options.logarithmic_decimals):
		if dec.length() < options.logarithmic_decimals:
			dec += "0"
	var formated_exponent := formatExponent(exponent)
	dec = dec.substr(0, min(options.logarithmic_decimals, options.dynamic_numbers - formated_exponent.length() if options.dynamic_decimals else options.logarithmic_decimals))
	return "e" + formated_exponent + options.decimal_separator + dec


## Formats an exponent for string format
func formatExponent(value) -> String:
	if value < 1000:
		return str(value)
	var string := str(value)
	var string_mod := string.length() % 3
	var output := ""
	for i in range(0, string.length()):
		if i != 0 and i % 3 == string_mod:
			output += options.thousand_separator
		output += string[i]
	return output


## Converts the Big Number into a float
func toFloat() -> float:
	return snappedf(float(str(mantissa) + "e" + str(exponent)),0.01)


func toPrefix(no_decimals_on_small_values = false, use_thousand_symbol=true, force_decimals=true, scientic_prefix=false) -> String:
	var number: float = mantissa
	if not scientic_prefix:
		var hundreds = 1
		for _i in range(exponent % 3):
			hundreds *= 10
		number *= hundreds

	var split := str(number).split(".")
	if split.size() == 1:
		split.append("")
	if force_decimals:
		var max_decimals = max(max(options.small_decimals, options.thousand_decimals), options.big_decimals)
		for i in range(max_decimals):
			if split[1].length() < max_decimals:
				split[1] += "0"
	
	if no_decimals_on_small_values and exponent < 3:
		return split[0]
	elif exponent < 3:
		if options.small_decimals == 0 or split[1] == "":
			return split[0]
		else:
			return split[0] + options.decimal_separator + split[1].substr(0,min(options.small_decimals, options.dynamic_numbers - split[0].length() if options.dynamic_decimals else options.small_decimals))
	elif exponent < 6:
		if options.thousand_decimals == 0 or (split[1] == "" and use_thousand_symbol):
			return split[0]
		else:
			if use_thousand_symbol: # when the prefix is supposed to be using with a K for thousand
				for i in range(3):
					if split[1].length() < 3:
						split[1] += "0"
				return split[0] + options.decimal_separator + split[1].substr(0,min(3, options.dynamic_numbers - split[0].length() if options.dynamic_decimals else 3))
			else:
				for i in range(3):
					if split[1].length() < 3:
						split[1] += "0"
				return split[0] + options.thousand_separator + split[1].substr(0,3)
	else:
		if options.big_decimals == 0 or split[1] == "":
			return split[0]
		else:
			return split[0] + options.decimal_separator + split[1].substr(0,min(options.big_decimals, options.dynamic_numbers - split[0].length() if options.dynamic_decimals else options.big_decimals))


func _latinPower(european_system) -> int:
	if european_system:
		@warning_ignore("integer_division")
		return int(exponent / 3) / 2
	@warning_ignore("integer_division")
	return int(exponent / 3) - 1



func _tillionOrIllion(european_system) -> String:
	if exponent < 6:
		return ""
	var powerKilo := _latinPower(european_system) % 1000
	if powerKilo < 5 and powerKilo > 0 and _latinPower(european_system) < 1000:
		return ""
	if (
			powerKilo >= 7 and powerKilo <= 10
			or int(powerKilo / floor(10)) % 10 == 1
	):
		return "i"
	return "ti"


func _llionOrLliard(european_system) -> String:
	if exponent < 6:
		return ""
	if int(exponent/floor(3)) % 2 == 1 and european_system:
		return "lliard"
	return "llion"



#On passe sur nos méthodes la

#Override pour le print
func _to_string():
	if exponent < 6:
		var toReturn = mantissa * (10**exponent)
		if toReturn > 1000:
			toReturn = round(toReturn)
		return str(toReturn)
	else:
		return str(mantissa).substr(0, 4) + "e" + str(exponent)


#Permet de soustraire deux chiffre en notation comme on a
func subTest(numberToMinus:Big):
	var newDecimal = mantissa
	var newExpo = exponent
	if exponent - numberToMinus.exponent <= 5:
		#On calcul le decimal
		newDecimal = RoundFloat5Decimal(mantissa - (numberToMinus.mantissa / 10 ** (exponent - numberToMinus.exponent)))
		
		#Si on a des 0 avant la virgule, il faut les virer
		while str(newDecimal)[0] == "0":
			newDecimal = RoundFloat5Decimal(newDecimal * 10)
			newExpo -= 1
			
	return Big.new(newDecimal, newExpo)


#Moins, et round 
static func subtractAbove0(x, y) -> Big:
	var negated_y := Big.new(-y.mantissa, y.exponent)
	var result = add(x, negated_y)
	#Si on a des 0 avant la virgule, il faut les virer
	while str(result.mantissa)[0] == "0":
		result.mantissa = result.mantissa * 10
		result.exponent -= 1
	return result


#Permet de couper le chiffre à la 5eme décimale
func RoundFloat5Decimal(number):
	return float(str(number).substr(0, 7))


func ToJsonFormat():
	return [mantissa, exponent]


static func ToCustomFormat(jsonList:Array):
	return Big.new(jsonList[0], jsonList[1])
