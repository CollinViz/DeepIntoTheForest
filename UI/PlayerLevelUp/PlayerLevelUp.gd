extends Control

export var clear:=false

onready var butHealth = $VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer/Health
onready var butSpeed = $VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer/Speed
onready var butDPS = $VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer/DPS
onready var butShelled = $VBoxContainer/CenterContainer2/VBoxContainer/HBoxContainer/Shelld



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# var buttonShow = PlayerDb.getNextLevelOptions()
	# if !buttonShow.has("Health"):
	# 	butHealth.visible=false
	# if !buttonShow.has("Speed"):
	# 	butSpeed.visible=false
	# if !buttonShow.has("DPS"):
	# 	butDPS.visible=false
	# if !buttonShow.has("butShelled"):
	# 	butShelled.visible=false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Health_pressed():
	PlayerDb.takeItem("MaxHealth")
	PlayerDb.LevelUp()
	GameDb.BackToNextDoor()


func _on_Speed_pressed():
	PlayerDb.takeItem("MoveSpeed")
	PlayerDb.LevelUp()
	GameDb.BackToNextDoor()


func _on_DPS_pressed():
	PlayerDb.takeItem("BaseDamage")
	PlayerDb.LevelUp()
	GameDb.BackToNextDoor()


func _on_Shelld_pressed():
	PlayerDb.takeItem("BaseBlock")
	PlayerDb.LevelUp()
	GameDb.BackToNextDoor()
