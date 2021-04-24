extends Node2D
export(PackedScene) var Blood
export(PackedScene) var ItemSpawner

onready var fxSpawner = $FXEnemy

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerDb.reset()


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
		print("Well done all dead")
