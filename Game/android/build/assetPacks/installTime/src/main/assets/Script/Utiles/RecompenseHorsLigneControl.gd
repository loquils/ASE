extends Control

@onready var DescriptionLabel = $GlobalPanelC/FenetrePanelC/PresentationVBoxC/DescriptionMarginC/DescriptionFondPanelC/VBoxC/DescriptionLabel
@onready var RecompensesVBoxC = $GlobalPanelC/FenetrePanelC/PresentationVBoxC/DescriptionMarginC/DescriptionFondPanelC/VBoxC/RecompensesVBoxC
@onready var PresentationDescriptionVboxC = $GlobalPanelC/FenetrePanelC/PresentationVBoxC/DescriptionMarginC/DescriptionFondPanelC/VBoxC
@onready var LoadingLabel = $GlobalPanelC/FenetrePanelC/PresentationVBoxC/DescriptionMarginC/DescriptionFondPanelC/LoadingLabel
@onready var RechargerHBoxC = $GlobalPanelC/FenetrePanelC/PresentationVBoxC/DescriptionMarginC/DescriptionFondPanelC/VBoxC/RechargerHBoxC

@onready var RecupererButton = $GlobalPanelC/FenetrePanelC/PresentationVBoxC/ButtonsMarginC/RecupererButton
@onready var CancelButton = $GlobalPanelC/FenetrePanelC/PresentationVBoxC/ButtonsMarginC/CancelButton

var CustomLine = preload("res://Design/Scenes/Utiles/CanvasBonusHorsLigneLineControl.tscn")

var MaxTempsOffLineInHours = 4
var MinTempsOfflineInMinutes = 3
var ListBonusOffLine = {}

var TempsOffline = 0

var DateDuSystem
var HeaderTime

func _on_request_completed(result, response_code, headers, body):
	for header in headers:
		if header.contains("Date"):
			HeaderTime = header.replace("Date: ", "")
	
	if HeaderTime == null or not VerifyCurrentTime():
		DescriptionLabel.text = tr("ERRORLOADING")
		DescriptionLabel.add_theme_color_override("font_color", Color.RED)
		LoadingLabel.hide()
		PresentationDescriptionVboxC.visible = true
		RechargerHBoxC.show()
		RecupererButton.hide()
		CancelButton.show()
	else:
		DescriptionLabel.text = tr("HORSLIGNE") + str(TempsOffline/3600) + tr("HEURES") + " " + str((TempsOffline%3600)/60) + tr("MINUTES")
		DescriptionLabel.remove_theme_color_override("font_color")
		LoadingLabel.hide()
		PresentationDescriptionVboxC.visible = true
		RecupererButton.show()
		CancelButton.hide()


func VerifyCurrentTime():
	var regex = RegEx.new()
	regex.compile("[a-zA-Z]+, (?<day>\\d+) (?<month>[a-zA-Z]+) (?<year>\\d+) (?<time>\\d+:\\d+:\\d+) [a-zA-Z]+")

	DateDuSystem = Time.get_datetime_dict_from_system(true)

	var resultRegex = regex.search(HeaderTime)
	if not int(resultRegex.get_string("year")) == DateDuSystem["year"]:
		return false
	if not int(resultRegex.get_string("day")) == DateDuSystem["day"]:
		return false
	if not int(resultRegex.get_string("time").split(":")[0]) == DateDuSystem["hour"]:
		return false
	
	return true


# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request("https://google.com")
	
	var dateDerniereModfication = FileAccess.get_modified_time("user://savegame.save")
	var dateDuSystem = Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system(true))
	
	#Si on est supérieur au temps maximum, on set la différence au temps Maximum.
	TempsOffline = dateDuSystem - dateDerniereModfication
	if TempsOffline > MaxTempsOffLineInHours * 3600:
		TempsOffline = MaxTempsOffLineInHours * 3600
	
	#Si on est en dessous du minimum de minutes.
	if TempsOffline < MinTempsOfflineInMinutes * 60:
		SuppressionFenetre()
	
	for atome in RessourceManager.ListeAtomes:
		if RessourceManager.ListeAtomes[atome].isUnlocked:
			ListBonusOffLine[atome] = RessourceManager.CalculateQuantityOneAtome(atome, TempsOffline)
	
	DescriptionLabel.text = str(TempsOffline/3600) + " " + tr("HEURES") + " " + str((TempsOffline%3600)/60) + " " + tr("MINUTES")
	
	#Maj de l'UI
	for atome in ListBonusOffLine:
		var line = CustomLine.instantiate()
		line._set_vars(atome, ListBonusOffLine[atome])
		RecompensesVBoxC.add_child(line)


#Permet de supprimer la fenêtre de récompense hors ligne.
#On save pour eviter qu'il y ait un problème avec les récompenses.
func SuppressionFenetre():
	ListBonusOffLine.clear()
	Save.save_game()
	hide()


#Trigger lors de l'appuie pour la récupération de la récompense.
func _on_recuperer_button_pressed():
	for atome in ListBonusOffLine:
		RessourceManager.QuantiteesAtomes[atome] = Big.add(RessourceManager.QuantiteesAtomes[atome], ListBonusOffLine[atome])
	SuppressionFenetre()


#Lors de l'appuie sur le bouton cancel
func _on_cancel_button_pressed():
	SuppressionFenetre()


#Lors de l'appuie sur le bouton recharger.
func _on_recharger_button_pressed():
	LoadingLabel.show()
	PresentationDescriptionVboxC.visible = false
	RechargerHBoxC.hide()
	$HTTPRequest.request("https://google.com")
