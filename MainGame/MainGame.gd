extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenu.visible=false
	var lev = GameDb.CurrentRoom.scene.instance()
	$CurrentLevel.add_child(lev)
	var _x = GameDb.connect("changeLevel",self,"LevelChange")

func LevelChange(NewCurrentLevel):
	if $CurrentLevel.get_child_count()>0:
		for c  in $CurrentLevel.get_children():						
			$CurrentLevel.remove_child(c)
			c.queue_free()
	var lev = NewCurrentLevel.scene.instance()
	$CurrentLevel.add_child(lev) 
