extends Node

var LanguageCourrant = "fr"

func maj_langue(langue):
	LanguageCourrant = langue
	TranslationServer.set_locale(langue)
