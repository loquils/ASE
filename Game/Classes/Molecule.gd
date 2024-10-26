class_name Molecule

var Id
var Name
var Description
var Prix
var IsUnlocked = false
var Augmentation:Array
var AugmentationPercent

func _init(id, name, prix: Big, augmentation, augmentationPercent: Big):
	Id = id
	Name = name
	Prix = prix
	Augmentation = augmentation
	AugmentationPercent = augmentationPercent
