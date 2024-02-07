class_name Recherche

var Id
var Nom
var Description
var Prix
var Achete = false
var Augmentation
var AugmentationPercent

func _init(id, nom, description, prix, augmentation, augmentationPercent):
	Id = id
	Nom = nom
	Description = description
	Prix = prix
	Augmentation = augmentation
	AugmentationPercent = augmentationPercent
