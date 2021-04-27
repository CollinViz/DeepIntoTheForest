extends Control

export (PackedScene) var StartScreen
export (PackedScene) var intoScreen
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenu.visible=false
	var lev = StartScreen.instance()
	$CurrentLevel.add_child(lev)
	var _x = GameDb.connect("changeLevel",self,"LevelChange")
	var _y = PlayerDb.connect("PlayerDied",self,"playerDeath")
	
	_x = MusicManager.connect("PlayerHit",self,"player_hit")
	_x = MusicManager.connect("EnemyDead",self,"enemy_dead")
	_x = MusicManager.connect("PlayBossMusic",self,"play_boss_music")
	_x = MusicManager.connect("PlayerCollect",self,"player_collect")
	_x = MusicManager.connect("LevelWin",self,"level_win")
	_x = MusicManager.connect("PlayBossMusicEnd",self,"play_boss_music_end")
	
	

func LevelChange(NewCurrentLevel):
	if $CurrentLevel.get_child_count()>0:
		for c  in $CurrentLevel.get_children():						
			$CurrentLevel.remove_child(c)
			c.queue_free()
	var lev = NewCurrentLevel.scene.instance()
	
	lev.clear=NewCurrentLevel.clear
	$CurrentLevel.add_child(lev) 


func playerDeath():
	GameDb.GoingThroughDoor("dead")


func player_hit():
	if !$playerHit.playing:
		$playerHit.play()

func enemy_dead():
	if !$EnemyDie.playing:
		$EnemyDie.play() 

func play_boss_music():	 
	if !$BossMusic.playing:
		$BossMusic.play() 
		
func play_boss_music_end():
	$BossMusic.stop() 
	
func player_collect():
	if !$Collect.playing:
		$Collect.play() 

func level_win():
	if !$LevelWin.playing:
		$LevelWin.play() 
