extends Control

@onready var NoyauSprite2D = $Node2DLithium/NoyauSprite2D
@onready var AmeliorationNoyauMenu = $PresentationVBoxC/MenuMarginC

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("2D_mouse_click") and visible and NoyauSprite2D.get_rect().has_point(NoyauSprite2D.to_local(get_global_mouse_position()))):
		if (!AmeliorationNoyauMenu.visible):
			AmeliorationNoyauMenu.show()
			$Node2DLithium.position -= Vector2(0,100)
		else:
			AmeliorationNoyauMenu.hide()
			$Node2DLithium.position += Vector2(0,100)


#Trigger lors de l'appuie sur le bouton exit
func _on_button_exit_pressed():
	hide()


#Trigger lors de l'appuie sur le bouton close du menu d'améliorations
func _on_button_close_pressed():
	AmeliorationNoyauMenu.hide()
	$Node2DLithium.position += Vector2(0,100)
