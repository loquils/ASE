extends Node

var languageCourrant = "fr"

func maj_langue(langue):
	languageCourrant = langue
	TranslationServer.set_locale(langue)
