class_name Recherche

var Id
var Name
var Description
var Prix
var Achete = false
var Augmentation
var AugmentationPercent

func _init(id, name, description, prix:CustomNumber, augmentation, augmentationPercent):
	Id = id
	Name = name
	Description = description
	Prix = prix
	Augmentation = augmentation
	AugmentationPercent = augmentationPercent
