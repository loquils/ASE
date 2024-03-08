class_name AmeliorationDarkMatter

var Id
var Name
var Description
var Prix
var IsUnlocked = false
var Augmentation

func _init(id, name, description, prix: CustomNumber, augmentation: CustomNumber):
	Id = id
	Name = name
	Description = description
	Prix = prix
	Augmentation = augmentation
