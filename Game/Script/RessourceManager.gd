extends Node

var Coins
var QuantiteesAtomes = {}

#Liste de tous les atomes, pour avoir un accès de partout
var ListeAtomes

# Called when the n*ode enters the scene tree for the first time.
func _ready():
	#On définit les atomes auxquels on a accès :)
	var newAtome = Atome.new("Hydrogene", 1.0, 1.0)
	var ListeAttribsTest = [AttributAtome.new(newAtome, "Force", 0, 1.15, 1.07, 10), AttributAtome.new(newAtome, "Vitesse", 0, 1.40, 1.15, 15)] #AttributAtome.new(newAtome, "COIIIn", 0, 20, 50, 100)
	newAtome.DefineAtomeAttributs(ListeAttribsTest)
	newAtome.isUnlocked = true
	
	var newAtome2 = Atome.new("Helium", 0.25, 0)
	var ListeAttribsTest2 = [AttributAtome.new(newAtome2, "Spin", 0, 1.32, 1.12, 50), AttributAtome.new(newAtome2, "Angle", 0, 1.40, 1.2, 50), AttributAtome.new(newAtome2, "Complexity", 0, 1.6, 1.5, 100)]
	newAtome2.DefineAtomeAttributs(ListeAttribsTest2)
	newAtome2.DefineAtomeUnlockingPrice({"Hydrogene" : 100})
	
	var newAtome3 = Atome.new("Fer", 0.3, 0)
	var ListeAttribsTest3 = [AttributAtome.new(newAtome3, "Tourette", 0, 10, 50, 5)]
	newAtome3.DefineAtomeAttributs(ListeAttribsTest3)
	newAtome3.DefineAtomeUnlockingPrice({"Helium" : 100})
	
	ListeAtomes = {"Hydrogene" : newAtome, "Helium" : newAtome2, "Fer" : newAtome3}
	
	
	
	for atome in ListeAtomes:
		QuantiteesAtomes[atome] = 0
		
	Coins = 10000


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
