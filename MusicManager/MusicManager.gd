extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal PlayerHit
signal EnemyDead
signal PlayBossMusic
signal PlayBossMusicEnd
signal PlayerCollect
signal LevelWin

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func player_hit():
	emit_signal("PlayerHit")

func enemy_dead():
	emit_signal("EnemyDead") 

func play_boss_music():
	emit_signal("PlayBossMusic") 
func play_boss_music_end():
	emit_signal("PlayBossMusicEnd") 
	
func player_collect():
	emit_signal("PlayerCollect") 

func level_win():
	emit_signal("LevelWin") 
