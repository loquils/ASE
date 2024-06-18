extends Node

signal changement_langue(langue)

var languageCourrant = "fr"

func maj_langue(langue):
	languageCourrant = langue
	TranslationServer.set_locale(langue)
	emit_signal("changement_langue", langue)
