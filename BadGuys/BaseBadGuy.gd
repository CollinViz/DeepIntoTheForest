extends KinematicBody2D
export var Attack:int = 3
export var AttackTimer:float = 1.0
export var MaxHP:int = 10
export var rotate_speed=100
export var spawn_pont_count=4
export var radius=100
export var predict_time:float=5.0
export var linear_speed_max:int=100
export var linear_accel_max:int=100
export var use_seek:bool=false
export var arrival_tolerance:float = 10
export var isAgrow:bool = false
export var reHuntTimer:float=2.0
export(Array, PackedScene) var ItemsList = []
export(Array,int) var BulletTypes = [1]
export(PackedScene) var BulletScene
export var EnemyAIType:int = 1  #1-direct attack
								#2-Charge
								#3-range attack

var target:Node = null
var _blend: GSAIBlend
var _direction_face := GSAIAgentLocation.new()
var behavior: GSAISteeringBehavior
var _angular_drag := 0.1
var _linear_drag_coefficient := 0.025

onready var EnemyFSM = $EnemyFSM
onready var DetectionArea:Area2D = $EnemyBod
onready var Rotator = $Rotator
onready var agent := GSAIKinematicBody2DAgent.new(self)
onready var accel := GSAITargetAcceleration.new()
onready var player_agent: GSAISteeringAgent = null #owner.find_node("Player", true, false).agent
# Called when the node enters the scene tree for the first time.
func _ready():
	EnemyFSM.set_state(EnemyFSM.states.idle)
	$HeathSystem.setMaxHeath(MaxHP)
	match EnemyAIType:		
		3:
			on_ready_shooter()
			 

func on_ready_shooter():
	var step = 2 * PI / spawn_pont_count
	for r in Rotator.get_children():
		r.queue_free()
		
	for i in range(spawn_pont_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius,0).rotated(step*i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		Rotator.add_child(spawn_point)

func _physics_process(delta):
	$Sprite.rotation = -1*self.rotation
	#var pos = Vector2(-21.768,-50.657).rotated((-1*self.rotation)+deg2rad(90))
	$HeathSystem.rotation = -1*self.rotation
	#$HeathSystem.position = Vector2(-20,-20)
	#$HeathSystem.position = pos
	$Status.rect_rotation = -1*self.rotation
	match EnemyAIType:
		1:
			EnemyChomp(delta)
		2:
			EnemyRush(delta)
		3:
			EnemyShoot(delta)
	

func EnemyChomp(delta):
	if player_agent == null:
		return
	_direction_face.position = agent.position + accel.linear.normalized()
	_direction_face.orientation =0
	_blend.calculate_steering(accel)
	agent.angular_velocity = clamp(
		agent.angular_velocity + accel.angular * delta, -agent.angular_speed_max, agent.angular_speed_max
	)
	agent.angular_velocity = lerp(agent.angular_velocity, 0, _angular_drag)

	rotation += agent.angular_velocity * delta
	
	var linear_velocity = (
		GSAIUtils.to_vector2(agent.linear_velocity)
		+ (GSAIUtils.angle_to_vector2(rotation) * -agent.linear_acceleration_max * delta)
	)
	linear_velocity = linear_velocity.clamped(agent.linear_speed_max)
	linear_velocity = linear_velocity.linear_interpolate(Vector2.ZERO, _linear_drag_coefficient)

	linear_velocity = move_and_slide(linear_velocity)
	agent.linear_velocity = GSAIUtils.to_vector3(linear_velocity)

func EnemyRush(delta):
	if player_agent == null:
		return
	_direction_face.position = agent.position + accel.linear.normalized()
	_direction_face.orientation =0
	_blend.calculate_steering(accel)
	agent.angular_velocity = clamp(
		agent.angular_velocity + accel.angular * delta, -agent.angular_speed_max, agent.angular_speed_max
	)
	agent.angular_velocity = lerp(agent.angular_velocity, 0, _angular_drag)

	rotation += agent.angular_velocity * delta
	
	var linear_velocity = (
		GSAIUtils.to_vector2(agent.linear_velocity)
		+ (GSAIUtils.angle_to_vector2(rotation) * -agent.linear_acceleration_max * delta)
	)
	linear_velocity = linear_velocity.clamped(agent.linear_speed_max)
	linear_velocity = linear_velocity.linear_interpolate(Vector2.ZERO, _linear_drag_coefficient)

	linear_velocity = move_and_slide(linear_velocity)
	agent.linear_velocity = GSAIUtils.to_vector3(linear_velocity)
	var to_target := global_position - GSAIUtils.to_vector2( player_agent.position)
	var distance := to_target.length()

	if distance <= arrival_tolerance:
		agent.linear_velocity = GSAIUtils.to_vector3(Vector2(0,0))
		print(" distance %d" % distance)
		player_agent = null
		EnemyFSM.set_state(EnemyFSM.states.idleHunt)

func EnemyShoot(delta):
	var new_rotation = Rotator.rotation_degrees + rotate_speed * delta
	Rotator.rotation_degrees = fmod(new_rotation,360)
	 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _takeDamage():
	pass


func takeDamage(NumHit:int)->void:
	checkTargetPlayer()
	MaxHP=MaxHP-NumHit
	if(MaxHP<=0):
		MusicManager.enemy_dead()
		print("You Killed me")
		get_parent().get_parent().spawn_loot(ItemsList,global_position)
		queue_free()
	$HeathSystem.call_deferred("UpdateHeath",MaxHP)
	_takeDamage()



func checkTargetPlayer():
	if target ==null:
		isAgrow = true
		target = PlayerDb.getPlayerNode()
		EnemyFSM.set_state(EnemyFSM.states.hunt)


func is_in_Range()->bool:
	return true

func sleep_reHunt()->void:
	yield(get_tree().create_timer(reHuntTimer), "timeout")
	EnemyFSM.set_state(EnemyFSM.states.huntSeek)
	
func check_playerInArea():
	var allBody = DetectionArea.get_overlapping_bodies()
	var has_player = false
	print(allBody)
	for b in allBody:
		if b.is_in_group("player"):
			has_player=true
	if has_player:
		return EnemyFSM.states.hunt
	return EnemyFSM.states.idle

func updateStatusText(StatusText:String)->void:
	var strMonsterType = ""
	match EnemyAIType:
		1:
			strMonsterType = "Chomp"
		2:
			strMonsterType = "Rush"
		3:
			strMonsterType = "Shoot"
	$Status.text= StatusText + " T: " + strMonsterType

func clear_target():
	player_agent = null
	target=null

func can_start_Shooting():
	match EnemyAIType:		
		3:
			_on_AttackTimer_timeout()
func FinedPlayer():
	agent.calculate_velocities = false
	if EnemyAIType==2:
		player_agent = GSAISteeringAgent.new()
		player_agent.position = GSAIUtils.to_vector3(target.global_position)
		#player_agent = target.agent
	else:
		player_agent = target.agent
	# var predict_time = 5
	# var linear_speed_max = 100
	# var linear_accel_max = 100
	# var use_seek= false
	# arrival_tolerance = 10
	# match EnemyAIType:
	# 	1:
	# 		predict_time = 5
	# 		linear_speed_max = 100
	# 		linear_accel_max = 100
	# 		use_seek = true
	# 	2:
	# 		predict_time = 5
	# 		linear_speed_max = 250
	# 		linear_accel_max = 500
	# 		use_seek = false
	# 		arrival_tolerance = 25
	# 	3:
	# 		pass


	if EnemyAIType==3:
		pass
	else:
		setup(predict_time,linear_speed_max,linear_accel_max,use_seek)
	#look how far player is 
	

func setup(predict_time: float, linear_speed_max: float, linear_accel_max: float,use_seek:bool) -> void:
	
	if use_seek:
		behavior = GSAISeek.new(agent, player_agent)
	else:
		behavior = GSAIPursue.new(agent, player_agent, predict_time)

	var orient_behavior := GSAIFace.new(agent, _direction_face)
	orient_behavior.alignment_tolerance = deg2rad(5)
	orient_behavior.deceleration_radius = deg2rad(5)

	_blend = GSAIBlend.new(agent)
	_blend.add(behavior, 1)
	_blend.add(orient_behavior, 1)

	agent.angular_acceleration_max = deg2rad(1080)
	agent.angular_speed_max = deg2rad(360)
	agent.linear_acceleration_max = linear_accel_max
	agent.linear_speed_max = linear_speed_max

	set_physics_process(true)
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if EnemyFSM.state==EnemyFSM.states.idle:
			target = body
			EnemyFSM.set_state(EnemyFSM.states.hunt)


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		if !isAgrow: 
			match EnemyAIType:
				1:
					OutOfRangeComp(body)
				2:
					OutOfRangeRush(body)
				3:
					OutOfRangeShoot(body)
			
func OutOfRangeComp(_body):
	target = null
	player_agent = null
	print("Player out of Area")
	EnemyFSM.set_state(EnemyFSM.states.idle)


func OutOfRangeRush(_body):
	pass
	#if EnemyFSM.state!=EnemyFSM.states.shoot:
	#	print("Player out of Area")
	#	EnemyFSM.set_state(EnemyFSM.states.idle)
func OutOfRangeShoot(_body):
	pass
func _on_EnemyBod_body_entered(body):
	if body.is_in_group("player"):
		body.takeDamage(Attack)
		$AttackTimer.start(AttackTimer)


func _on_AttackTimer_timeout():
	if target!=null:
		match EnemyAIType:
			1:
				AttackTimerComp()
			2:
				AttackTimerRush()
			3:
				AttackTimerShoot()
		
func AttackTimerComp():
	target.takeDamage(Attack)
	$AttackTimer.start(AttackTimer)

func AttackTimerRush():
	target.takeDamage(Attack)
	$AttackTimer.start(AttackTimer)


func AttackTimerShoot():
	for r in Rotator.get_children():
		var b = BulletScene.instance()
		b.setDamage(Attack,1,"Normal",250)
		get_parent().get_parent().BulletEnemy.add_child(b)
		b.position = r.global_position
		b.rotation = r.global_rotation

	##get_parent().get_parent().CreateBullets(BulletScene,BulletTypes,10,10,Vector2(0,360),self.global_position)
	$AttackTimer.start(AttackTimer)

func _on_EnemyBod_body_exited(body):
	if body.is_in_group("player"):
		$AttackTimer.stop()
