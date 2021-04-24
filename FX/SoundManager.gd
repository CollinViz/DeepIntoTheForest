extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var sd_enemy_hit = preload("res://assest/sound/mage_hit_enamy.wav")
var sd_enemy_steal = preload("res://assest/sound/steal_item.wav")
var sd_player_pickup = preload("res://assest/sound/item_pickup.wav")
var sd_printer_page = preload("res://assest/sound/print_page.wav")
var sd_printer_put = preload("res://assest/sound/put_printer.wav")
 
# Called when the node enters the scene tree for the first time.
func _ready():
	if !SoundController.play_background:
		background_off()
	else:
		background_on()
	if !SoundController.play_sound:
		sound_off()
	else:
		sound_on()
# warning-ignore:return_value_discarded
	SoundController.connect("background_off",self,"background_off")
# warning-ignore:return_value_discarded
	SoundController.connect("background_on",self,"background_on")
# warning-ignore:return_value_discarded	
	SoundController.connect("sound_on",self,"sound_on")
# warning-ignore:return_value_discarded	
	SoundController.connect("sound_off",self,"sound_off")

# warning-ignore:return_value_discarded
	SoundController.connect("enemy_hit",self,"enemy_hit")
# warning-ignore:return_value_discarded	
	SoundController.connect("enemy_steal",self,"enemy_steal")
# warning-ignore:return_value_discarded
	SoundController.connect("player_pickup",self,"player_pickup")
# warning-ignore:return_value_discarded	
	SoundController.connect("printer_page",self,"printer_page")
# warning-ignore:return_value_discarded	
	SoundController.connect("printer_put",self,"printer_put")

func background_off():	
	$world.stop()
	pass

func background_on():
	$world.play()
	pass

func sound_on():	
	pass

func sound_off():
	$Player.stop()
	$Enemy.stop()
	$Printer.stop()
	pass

func enemy_hit():
	$Enemy.stream = sd_enemy_hit
	$Enemy.play()
	pass

func enemy_steal():
	pass

func player_pickup():
	$Player.stream = sd_player_pickup
	$Player.play()
	pass

func printer_page():
	$Printer.stream = sd_printer_page
	$Printer.play()
	pass

func printer_put():
	$Printer.stream = sd_printer_put
	$Printer.play()
	pass

