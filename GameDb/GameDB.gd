extends Node2D

export(PackedScene) var WinScreen = preload("res://UI/Win/Win.tscn")
export(PackedScene) var PlayerDied = preload("res://UI/PlayerDied/PlayerDied.tscn")
export(PackedScene) var PlayerLevelUp = preload("res://UI/PlayerLevelUp/PlayerLevelUp.tscn")
export(PackedScene) var Intro = preload("res://UI/IntroScreen/IntorScreen.tscn")
var level01 = []
var CurrentRoomIndex = 0
var CurrentRoom = null
var SavedNextDoor ="" 

var ShopItemsCanHave:Array = []
var ShopItems:Array = []

signal changeLevel(NewLevelScene)

func _ready():
	randomize()
	level01.push_back({"scene":preload("res://Leveles/RoomBStart/RoomBStart.tscn"),"door1":1,"clear":false}) #0
	level01.push_back({"scene":preload("res://Leveles/RoomTRB/RoomTBR.tscn"),"door1":0,"door2":2,"door3":4,"clear":false}) #1
	level01.push_back({"scene":preload("res://Leveles/RoomLR/RoomLR.tscn"),"door1":1,"door2":3,"clear":false}) #2
	level01.push_back({"scene":preload("res://Leveles/RoomL/RoomL.tscn"),"door1":2,"clear":false}) #3
	level01.push_back({"scene":preload("res://Leveles/RoomTLB/RoomTBLShop.tscn"),"door1":1,"door2":5,"door3":7,"clear":false}) #4
	level01.push_back({"scene":preload("res://Leveles/RoomBR/RoomBR.tscn"),"door1":6,"door2":4,"clear":false}) #5
	level01.push_back({"scene":preload("res://Leveles/RoomT/RoomT.tscn"),"door1":5,"clear":false}) #6
	level01.push_back({"scene":preload("res://Leveles/RoomRT/RoomRTFountain.tscn"),"door1":4,"door2":8,"clear":false})#7
	level01.push_back({"scene":preload("res://Leveles/EndBoss/EndBoss.tscn"),"door1":7,"clear":false}) #8
	level01.push_back({"scene":PlayerLevelUp,"door1":7,"clear":false}) #9
	level01.push_back({"scene":preload("res://Leveles/RoomTLB/RoomTBLShop.tscn"),"door1":7,"clear":false}) #9
	level01.push_back({"scene":preload("res://Leveles/RoomRT/RoomRTFountain.tscn"),"door1":7,"clear":false}) #9
	CurrentRoom = level01[0]
 

	ShopItemsCanHave.push_back({"name":"Health pack","description":"Gives player health","cost":10,"itemName":"Helth50"})
	ShopItemsCanHave.push_back({"name":"Fire Rate","description":"Improve gun fire rate","cost":25,"itemName":"ShotsCoolL2"})
	ShopItemsCanHave.push_back({"name":"Max Fire Rate","description":"Improve gun fire rate","cost":50,"itemName":"ShotsCoolL3"})
	ShopItemsCanHave.push_back({"name":"Boots of speed","description":"Improve movement speed","cost":25,"itemName":"MoveSpeed"})
	ShopItemsCanHave.push_back({"name":"Glass heart","description":"Improve max Health","cost":50,"itemName":"MaxHealth"})
	ShopItemsCanHave.push_back({"name":"Flash in pan","description":"Improve Stamina","cost":50,"itemName":"MaxStamina"})
	ShopItemsCanHave.push_back({"name":"Floating Shield","description":"Shield of protection","cost":50,"itemName":"shelled"})
	

func getShopItems()->Array:
	ShopItemsCanHave.shuffle()
	ShopItems =[]
	for n in 3:
		ShopItems.push_back(ShopItemsCanHave[n])	

	return ShopItems

func GoingThroughDoor(DoorName:String):
	if PlayerDb.ShouldLevelUp():
		SavedNextDoor = DoorName
		emit_signal("changeLevel",{"scene":PlayerLevelUp,"clear":false})
		return
	if DoorName=="intro":
		CurrentRoomIndex =0
		CurrentRoom = level01[0]
		emit_signal("changeLevel",{"scene":Intro,"clear":false})
	if DoorName=="done":
		CurrentRoomIndex =0
		CurrentRoom = level01[0]
		emit_signal("changeLevel",{"scene":WinScreen,"clear":false})
	if DoorName=="dead":
		CurrentRoomIndex =0
		CurrentRoom = level01[0]
		emit_signal("changeLevel",{"scene":PlayerDied,"clear":false})
	if DoorName=="restart":
		CurrentRoomIndex =0
		CurrentRoom = level01[0]
		emit_signal("changeLevel",CurrentRoom)
	if(CurrentRoom.has(DoorName)):
		if CurrentRoomIndex>0:
			level01[CurrentRoomIndex].clear = true
		CurrentRoomIndex = CurrentRoom[DoorName]
		CurrentRoom = level01[CurrentRoom[DoorName]]
		emit_signal("changeLevel",CurrentRoom)


func BackToNextDoor():
	GoingThroughDoor(SavedNextDoor)


func restart():
	CurrentRoom = level01[0]
	GoingThroughDoor("restart")
