extends Node2D

onready var Health:TextureProgress = $Heath
onready var Stamina:TextureProgress = $Stamina
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func setHealth(NewHealth:int,MaxHealth:int)->void:
	Health.value = NewHealth
	Health.max_value=MaxHealth

func setStamina(NewStamina:int,MaxStamina:int)->void:
	Stamina.value = NewStamina
	Stamina.max_value=MaxStamina


func PlayerDataChange():
	Health.value = PlayerDb.PlayerHealth
	Health.max_value=PlayerDb.PlayerMaxHealth
	Stamina.value = PlayerDb.PlayerStamina
	Stamina.max_value=PlayerDb.PlayerMaxStamina
# Called when the node enters the scene tree for the first time.
func _ready():
	var _x = PlayerDb.connect("HealthChange",self,"setHealth")
	var _y = PlayerDb.connect("StaminaChange",self,"setStamina")
	var _s = PlayerDb.connect("PlayerDataChange",self,"PlayerDataChange")
	PlayerDataChange()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
