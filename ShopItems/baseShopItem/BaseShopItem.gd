extends Node2D


export var ItemName:="Health"
export var ItemDescription:="Health"
export var ItemCost:=10
export var ItemType:="Helth50"


onready var img:=$Panel/CenterContainer/VBoxContainer/CenterContainer/TextureRect
onready var text:=$Panel/CenterContainer/VBoxContainer/RichTextLabel
onready var itemBox:=$Panel/CenterContainer
onready var detectionBox:=$Area2D
# Called when the node enters the scene tree for the first time.
var playerCanBuy:=false

var Helth50:=preload("res://ShopItems/shopHeath.png")
var ShotsCoolL2:=preload("res://ShopItems/shopGun.png")
var ShotsCoolL3:=preload("res://ShopItems/shopLazor.png")
var MoveSpeed:=preload("res://ShopItems/shopShelld.png")
var MaxHealth:=preload("res://ShopItems/shopHeath.png")
var MaxStamina:=preload("res://ShopItems/shopShelld.png")
var shelled:=preload("res://ShopItems/shopShelld.png")


func _ready():
	match ItemType:
		"Helth50":
			img.texture = Helth50
		"ShotsCoolL2":
			img.texture = ShotsCoolL2
		"ShotsCoolL3":
			img.texture = ShotsCoolL3
		"MoveSpeed":
			img.texture = MoveSpeed
		"MaxHealth":
			img.texture = MaxHealth
		"MaxStamina":
			img.texture = MaxStamina
		"shelled":
			img.texture = shelled

	text.bbcode_text = "[center]%s[/center]\n\n[center]%d Gold[/center]" % [ItemName,ItemCost]
	$Description.bbcode_text= "[center]%s[/center]" % ItemDescription
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(_body):
	if PlayerDb.getGold()>=ItemCost:
		PlayerDb.addGold(-1 * ItemCost)
		itemBox.visible = false
		detectionBox.visible = false
		PlayerDb.takeItem(ItemType)


func _on_Panel_mouse_entered():
	if !$Description.visible and itemBox.visible:
		$Description.visible=true


func _on_Panel_mouse_exited():
	$Description.visible=false
