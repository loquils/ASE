extends Node2D

@onready var ElectronK1Sprite2D = $ElectronK1Sprite2D
@onready var ElectronK2Sprite2D = $ElectronK2Sprite2D
@onready var ElectronL1Sprite2D = $ElectronL1Sprite2D


var d = 0.0
var radiusK = 200
var radiusL = 350
var speed = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	d += delta
	ElectronK1Sprite2D.position = Vector2(sin(d * speed) * radiusK, cos(d * speed) * radiusK)
	ElectronK2Sprite2D.position = Vector2(-sin(d * speed) * radiusK, -cos(d * speed) * radiusK)
	ElectronL1Sprite2D.position = Vector2(sin(d * speed) * radiusL, cos(d * speed) * radiusL)
	
