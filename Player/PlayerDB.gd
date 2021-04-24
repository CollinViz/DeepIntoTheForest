extends Node2D


export var PlayerHealth:int = 50
export var PlayerMaxHealth:int = 50
export var PlayerMaxStamina:int = 10
export var PlayerStamina:int = 10

export var PlayerMoveSpeed:int = 200
export var PlayerShotsCoolDownSec:float = 1
export var PlayerBaseDamage:int = 1
export var PlayerBaseBlock:int = 1


export var PlayerGold:int = 0
export var PlayerXP:int = 0

signal HealthChange(HealthVal,TotalHealth)
signal StaminaChange(StaminaVal,TotalStamina)
signal PlayerDataChange()
signal PlayerGoldChange(GoldVal)
signal PlayerXPChange(XpVal)
signal PlayerDied()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func addHealth(NewHealth:int)->void:
	if NewHealth<0:
		NewHealth = PlayerBaseBlock+ NewHealth
		
	if(PlayerHealth+NewHealth<PlayerMaxHealth):
		PlayerHealth = PlayerHealth+NewHealth
	else:
		PlayerHealth = PlayerMaxHealth
	if(PlayerHealth<0):
		PlayerHealth=0
		print("Player is dead game over")
		emit_signal("PlayerDied")
	emit_signal("HealthChange",PlayerHealth,PlayerMaxHealth)

func addStamina(NewStamina:int)->void:
	if(PlayerStamina+NewStamina<PlayerMaxStamina):
		PlayerStamina = PlayerStamina+NewStamina
	else:
		PlayerStamina = PlayerMaxStamina
	if(PlayerStamina<0):
		PlayerStamina=0
	
	emit_signal("StaminaChange",PlayerStamina,PlayerMaxStamina)


func addGold(NewGold:int)->void:
	PlayerGold=PlayerGold+NewGold
	print("Your Gold is %d" % PlayerGold)
	emit_signal("PlayerGoldChange",PlayerGold)

func addXP(NewXP:int)->void:
	PlayerXP=PlayerXP+NewXP
	print("Your Xp is %d" % PlayerXP)
	emit_signal("PlayerXPChange",PlayerGold)
	
func reset():
	PlayerMaxHealth  = 50
	PlayerHealth = PlayerMaxHealth
	PlayerMaxStamina  = 50
	PlayerStamina = PlayerMaxStamina

	PlayerMoveSpeed = 100
	PlayerShotsCoolDownSec = 0.5
	PlayerBaseDamage  = 1
	PlayerBaseBlock = 1
	PlayerGold=0
	PlayerXP =0
	emit_signal("PlayerDataChange")
	
func takeItem(ItemType:String)->void:
	match ItemType:
		"Gold":
			addGold(1)
		"XP":
			addXP(1)
		"Helth10":
			addHealth(10)
		"Helth20":
			addHealth(20)
		"Helth50":
			addHealth(50)
		"MaxStamina":
			PlayerMaxStamina=PlayerMaxStamina+ int(PlayerMaxStamina*0.50)
			addStamina(PlayerMaxStamina)
		"MaxHelth":
			PlayerMaxHealth=PlayerMaxHealth+ int(PlayerMaxHealth*0.50)
			addHealth(PlayerMaxHealth)
		"MoveSpeed":
			PlayerMoveSpeed=PlayerMoveSpeed+ int(PlayerMoveSpeed*0.50)
			emit_signal("PlayerDataChange")
		"BaseDamage":
			PlayerBaseDamage=PlayerBaseDamage+ int(PlayerBaseDamage*0.50)+1
			emit_signal("PlayerDataChange")
		"BaseBlock":
			PlayerBaseBlock=PlayerBaseBlock+ int(PlayerBaseBlock*0.50)+1
			emit_signal("PlayerDataChange")
		"ShotsCoolL1":
			PlayerShotsCoolDownSec = 0.2
			emit_signal("PlayerDataChange")
		"ShotsCoolL2":
			PlayerShotsCoolDownSec = 0.1
			emit_signal("PlayerDataChange")
		"ShotsCoolL3":
			PlayerShotsCoolDownSec = 0.05
			emit_signal("PlayerDataChange")