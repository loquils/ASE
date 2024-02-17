extends Node

var Coins
var QuantiteesAtomes = {}

#Liste de tous les atomes, pour avoir un accès de partout
var ListeAtomes

# Called when the n*ode enters the scene tree for the first time.
func _ready():
	#On définit les atomes auxquels on a accès :)
	var newAtome = Atome.new("Hydrogene", CustomNumber.new(1.0, 0), CustomNumber.new(1.0, 0))
	var ListeAttribsTest = [AttributAtome.new(newAtome, "Force", CustomNumber.new(), CustomNumber.new(1.15), CustomNumber.new(1.07), CustomNumber.new(10)), AttributAtome.new(newAtome, "Vitesse", CustomNumber.new(), CustomNumber.new(1.40), CustomNumber.new(1.15), CustomNumber.new(15))] #AttributAtome.new(newAtome, "COIIIn", 0, 20, 50, 100)
	newAtome.DefineAtomeAttributs(ListeAttribsTest)
	newAtome.isUnlocked = true
	
	var newAtome2 = Atome.new("Helium", CustomNumber.new(0.25, 0))
	var ListeAttribsTest2 = [AttributAtome.new(newAtome2, "Spin", CustomNumber.new(), CustomNumber.new(1.32), CustomNumber.new(1.12), CustomNumber.new(50)), AttributAtome.new(newAtome2, "Angle", CustomNumber.new(), CustomNumber.new(1.40), CustomNumber.new(1.2), CustomNumber.new(50)), AttributAtome.new(newAtome2, "Complexity", CustomNumber.new(), CustomNumber.new(1.6), CustomNumber.new(1.5), CustomNumber.new(100))]
	newAtome2.DefineAtomeAttributs(ListeAttribsTest2)
	newAtome2.DefineAtomeUnlockingPrice({"Hydrogene" : CustomNumber.new(1.0, 2)})
	
	#var newAtome3 = Atome.new("Fer", 0.3)
	#var ListeAttribsTest3 = [AttributAtome.new(newAtome3, "Tourette", 0, 10, 50, 5)]
	#newAtome3.DefineAtomeAttributs(ListeAttribsTest3)
	#newAtome3.DefineAtomeUnlockingPrice({"Helium" : 100})
	
	ListeAtomes = {"Hydrogene" : newAtome, "Helium" : newAtome2}
	
	for atome in ListeAtomes:
		QuantiteesAtomes[atome] = CustomNumber.new()
		
	Coins = CustomNumber.new(1.0, 4)
