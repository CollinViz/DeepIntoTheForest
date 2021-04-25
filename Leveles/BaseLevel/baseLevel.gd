extends Node2D
export(PackedScene) var Blood
export(PackedScene) var ItemSpawner
export(bool) var isFirstLevel = false

onready var fxSpawner = $FXEnemy
onready var BulletEnemy = $BulletEnemy
onready var BulletPlayer = $BulletPlayer
onready var Doors = $Doors

# Called when the node enters the scene tree for the first time.
func _ready():
	if isFirstLevel:
		PlayerDb.resetData($Player)
	else:
		PlayerDb._playerNode = $Player
	Doors.monitorable=false
	Doors.monitoring = false


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


 


func _on_Doors_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.is_in_group("player"):
		Doors.monitorable=true
		Doors.monitoring = true
		print(Doors.get_children()[local_shape].get_groups())
		print("Player going through doors",body_id, body, body_shape, local_shape)
		GameDb.GoingThroughDoor(Doors.get_children()[local_shape].get_groups()[0])
