extends CanvasLayer


onready var gold:RichTextLabel = $Panel/VBoxContainer/Gold
onready var xp:RichTextLabel = $Panel/VBoxContainer/XP
onready var level:RichTextLabel = $Panel/VBoxContainer/Level
onready var bar:TextureProgress = $Panel/VBoxContainer/CenterContainer2/TextureProgress

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerDb.connect("PlayerGoldChange",self,"GoldChange")
	PlayerDb.connect("PlayerXPChange",self,"XPChange")
	PlayerDb.connect("PlayerLevelChange",self,"LevelChange")
	GoldChange(PlayerDb.PlayerGold)
	XPChange(PlayerDb.PlayerXP,PlayerDb.PlayerXPNextLevel)
	LevelChange(PlayerDb.PlayerLevel,PlayerDb.PlayerXPNextLevel)

func GoldChange(GoldValue):
	gold.bbcode_text="[center]Gold: %d[/center]" %GoldValue



func XPChange(PlayerXP,PlayerXPNextLevel):
	bar.value=PlayerXP
	bar.max_value=PlayerXPNextLevel
 
func LevelChange(PlayerLevel,_PlayerXPNextLevel):
	level.bbcode_text ="[center]Level: %d[/center]" %(PlayerLevel+1)
