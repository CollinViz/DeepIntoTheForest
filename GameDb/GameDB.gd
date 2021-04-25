extends Node2D

export(PackedScene) var WinScreen = preload("res://UI/Win/Win.tscn")
export(PackedScene) var PlayerLevelUp = preload("res://UI/PlayerLevelUp/PlayerLevelUp.tscn")

var level01 = []
var CurrentRoom = null
var SavedNextDoor ="" 

signal changeLevel(NewLevelScene)

func _ready():

	level01.push_back({"scene":preload("res://Leveles/RoomBStart/RoomBStart.tscn"),"door1":1}) #0
	level01.push_back({"scene":preload("res://Leveles/RoomTRB/RoomTBR.tscn"),"door1":0,"door2":2,"door3":4}) #1
	level01.push_back({"scene":preload("res://Leveles/RoomLR/RoomLR.tscn"),"door1":1,"door2":3}) #2
	level01.push_back({"scene":preload("res://Leveles/RoomL/RoomL.tscn"),"door1":2}) #3
	level01.push_back({"scene":preload("res://Leveles/RoomTLB/RoomTLB.tscn"),"door1":1,"door2":5,"door3":7}) #4
	level01.push_back({"scene":preload("res://Leveles/RoomBR/RoomBR.tscn"),"door1":6,"door2":4}) #5
	level01.push_back({"scene":preload("res://Leveles/RoomT/RoomT.tscn"),"door1":5}) #6
	level01.push_back({"scene":preload("res://Leveles/RoomRT/RoomRT.tscn"),"door1":4,"door2":8})#7
	level01.push_back({"scene":preload("res://Leveles/EndBoss/EndBoss.tscn"),"door1":7}) #8
	CurrentRoom = level01[0]
 

func GoingThroughDoor(DoorName:String):
	if PlayerDb.ShouldLevelUp():
		SavedNextDoor = DoorName
		emit_signal("changeLevel",{"scene":PlayerLevelUp})
		return
	if DoorName=="done":
		CurrentRoom = level01[0]
		emit_signal("changeLevel",{"scene":WinScreen})
	if(CurrentRoom.has(DoorName)):
		CurrentRoom = level01[CurrentRoom[DoorName]]
		emit_signal("changeLevel",CurrentRoom)


func BackToNextDoor():
	GoingThroughDoor(SavedNextDoor)
