extends Node2D
export(PackedScene) var Blood
export(PackedScene) var ItemSpawner
export(bool) var isFirstLevel = false
export(bool) var clear = false

onready var fxSpawner = $FXEnemy
onready var BulletEnemy = $BulletEnemy
onready var BulletPlayer = $BulletPlayer
onready var Doors = $Doors
onready var RoomClearItems = $VisableOnClear

# Called when the node enters the scene tree for the first time.
func _ready():
	if isFirstLevel:
		PlayerDb.resetData($Player)
	else:
		PlayerDb._playerNode = $Player
	
	#Setup all room env
	Doors.monitorable=false
	Doors.monitoring = false
	RoomClearItems.visible = false
	
	#clear all enemies if room is clear
	if clear:
		for c  in $EnemySpawn.get_children():						
			$EnemySpawn.remove_child(c)
			c.queue_free()
		_on_AllDead_timeout()


func spawn_loot(ItemsList,pos):
	var node_instance = Blood.instance()
	fxSpawner.add_child(node_instance)
	node_instance.global_position = pos
	
	
	var spawn_instance = ItemSpawner.instance()
	fxSpawner.add_child(spawn_instance)
	spawn_instance.global_position = pos
	spawn_instance.createItems(ItemsList)


		
	

func _on_AllDead_timeout():
	if $EnemySpawn.get_child_count()==0:
		Doors.monitorable=true
		Doors.monitoring = true
		print("Well done all dead")
		$AllDead.stop()
		RoomClearItems.visible = true


 


func _on_Doors_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.is_in_group("player"):
		Doors.monitorable=true
		Doors.monitoring = true
		print(Doors.get_children()[local_shape].get_groups())
		print("Player going through doors",body_id, body, body_shape, local_shape)
		GameDb.GoingThroughDoor(Doors.get_children()[local_shape].get_groups()[0])
