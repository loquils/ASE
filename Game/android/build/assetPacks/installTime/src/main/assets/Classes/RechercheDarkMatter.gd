class_name RechercheDarkMatter

var Id
var Name
var Description
var Prix
var IsUnlocked = false
var Augmentation
var AugmentationPercent

func _init(id, name, description, prix: Big, augmentation, augmentationPercent: Big):
	Id = id
	Name = name
	Description = description
	Prix = prix
	Augmentation = augmentation
	AugmentationPercent = augmentationPercent
