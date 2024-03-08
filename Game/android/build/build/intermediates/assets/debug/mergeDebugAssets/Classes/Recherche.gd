class_name Recherche

var Id
var Name
var Description
var Prix
var IsUnlocked = false
var Augmentation
var AugmentationPercent
var ResearchLevel:ResearchLevelEnum

enum ResearchLevelEnum {EASY}

func _init(id, name, description, prix: CustomNumber, augmentation, augmentationPercent: CustomNumber, researchLevel):
	Id = id
	Name = name
	Description = description
	Prix = prix
	Augmentation = augmentation
	AugmentationPercent = augmentationPercent
	ResearchLevel = researchLevel
