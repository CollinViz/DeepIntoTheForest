extends KinematicBody2D
export (PackedScene) var Bullet
export var speed = 200  # speed in pixels/sec
export var FireDelayTimeOut:float = 0.1  # speed in pixels/sec
export var StaminaDelayTimeOut:float = 0.5  # speed in pixels/sec
export var StaminaRegenDelayTimeOut:float = 0.5  # speed in pixels/sec
export var IsGunAuto:bool = false
var velocity = Vector2.ZERO

onready var target = $Target
onready var muzzel = $Target/Sprite2
onready var muzzel2 = $muzzel
onready var HeathSystem = $HeathSystemView
onready var FireDelay:Timer = $FireDelay
onready var StaminaDelay:Timer = $StaminaDelay

onready var PlayerFSM:StateMachine = $PlayerFSM

onready var agent := GSAISteeringAgent.new()

func _ready():
	var _s = PlayerDb.connect("PlayerDataChange",self,"PlayerDataChange")
	PlayerFSM.set_state(PlayerFSM.states.idle)
	$Regen.start(StaminaRegenDelayTimeOut)
	 
func PlayerDataChange():
	speed = PlayerDb.PlayerMoveSpeed
	FireDelayTimeOut = PlayerDb.PlayerShotsCoolDownSec

func _input(_event):
	
	if Input.is_action_just_pressed("shoot") and FireDelay.is_stopped():
		FireDelay.start(FireDelayTimeOut)
		shoot()
	if Input.is_action_just_pressed("Dash"):
			PlayerFSM.set_state(PlayerFSM.states.dash)
	if Input.is_action_just_released("Dash"):
		PlayerFSM.set_state(PlayerFSM.states.idle)
	if Input.is_action_just_pressed("Dodge"):
			PlayerFSM.set_state(PlayerFSM.states.dodge)

		
func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	# Make sure diagonal movement isn't faster

	velocity = velocity.normalized() * speed * is_dash()
	
func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
	target.look_at(get_global_mouse_position())
	
	muzzel2.position = $Sprite.position + Vector2(cos(target.rotation), sin(target.rotation)) * 50
	
	if Input.is_action_pressed("shoot") and FireDelay.is_stopped() and IsGunAuto:
		FireDelay.start(FireDelayTimeOut)
		shoot()


	_update_agent()



func _update_agent() -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
	agent.linear_velocity.x = velocity.x
	agent.linear_velocity.y = velocity.y
	#agent.angular_velocity = _angular_velocity
	agent.orientation = rotation

func shoot():
	#PlayerFSM.set_state(PlayerFSM.states.shoot)
	var b = Bullet.instance()
	b.setDamage(PlayerDb.PlayerBaseDamage,2,"pop",1250) 
	b.transform = target.transform.scaled(Vector2(0.15,0.15)) 
	b.position = muzzel2.position
	 
	add_child(b)


func _on_Timer_timeout():
	#PlayerFSM.set_state(PlayerFSM.states.idle)
	pass
#PlayerDb.setHealth(-1)

func takeDamage(NumHit:int)->void:
	print("Geeting hit %d %d %d" % [PlayerDb.PlayerHealth,PlayerDb.PlayerMaxHealth,NumHit])
	match PlayerFSM.state:
		PlayerFSM.states.dodge:
			return
		PlayerFSM.states.dash:
			return	
		PlayerFSM.states.hit:
			return	
	PlayerDb.addHealth(-1 * NumHit)

 
#State Function calls:

func reduce_Stamina(cost:int):
	if StaminaDelay.is_stopped():
		StaminaDelay.start(StaminaDelayTimeOut)
		PlayerDb.addStamina(cost)

func Is_Stamina_empty()->bool:
	if(PlayerDb.PlayerStamina>0):
		return false
	return true

func is_dash()->int:
	if (PlayerFSM.state==PlayerFSM.states.dash):
		return 4
	return 1

func _on_Regen_timeout():
	if PlayerDb.PlayerStamina<PlayerDb.PlayerMaxStamina:
		PlayerDb.addStamina(1)
	#PlayerDb.addHealth(1)


func _on_PlayerBod_body_entered(body):
	pass # Replace with function body.
