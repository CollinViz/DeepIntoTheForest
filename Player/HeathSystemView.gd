extends Node2D

onready var Heath:TextureProgress = $Heath
onready var Stamana:TextureProgress = $Stamana
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func setHelth(NewHeath:int):
	Heath.value = NewHeath

func setStamana(NewSamana:int):
	Stamana.value = NewSamana

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
