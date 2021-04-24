extends KinematicBody2D
export var Attack:int = 3
export var AttackTimer:float = 1.0
export var MaxHP:int = 10
export(Array, PackedScene) var ItemsList = []
export var EnemyAIType:int = 1  #1-direct attack
								#2-range attack

onready var EnemyFSM = $EnemyFSM
var target:Node = null
var _blend: GSAIBlend
var _direction_face := GSAIAgentLocation.new()
var behavior: GSAISteeringBehavior
var _angular_drag := 0.1
var _linear_drag_coefficient := 0.025
onready var agent := GSAIKinematicBody2DAgent.new(self)
onready var accel := GSAITargetAcceleration.new()
onready var player_agent: GSAISteeringAgent = null #owner.find_node("Player", true, false).agent
# Called when the node enters the scene tree for the first time.
func _ready():
	$HeathSystem.setMaxHeath(MaxHP)
	pass # Replace with function body.

func _physics_process(delta):
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
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func takeDamage(NumHit:int)->void:
	MaxHP=MaxHP-NumHit
	if(MaxHP<=0):
		print("You Killed me")
		get_parent().get_parent().spawn_loot(ItemsList,global_position)
		queue_free()
	$HeathSystem.call_deferred("UpdateHeath",MaxHP)

func is_in_Range()->bool:
	return true

func FinedPlayer():
	agent.calculate_velocities = false
	player_agent = target.agent
	setup(5.0,100,100)
	#look how far player is 
	pass

func setup(predict_time: float, linear_speed_max: float, linear_accel_max: float) -> void:
	
	#if use_seek:
	#behavior = GSAISeek.new(agent, player_agent)
	#else:
	behavior = GSAIPursue.new(agent, player_agent, predict_time)

	var orient_behavior := GSAIFace.new(agent, _direction_face)
	orient_behavior.alignment_tolerance = deg2rad(5)
	orient_behavior.deceleration_radius = deg2rad(30)

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
		target = body
		EnemyFSM.set_state(EnemyFSM.states.hunt)


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		target = null
		player_agent = null
		EnemyFSM.set_state(EnemyFSM.states.idle)


func _on_EnemyBod_body_entered(body):
	if body.is_in_group("player"):
		body.takeDamage(Attack)
		$AttackTimer.start(AttackTimer)


func _on_AttackTimer_timeout():
	if target!=null:
		target.takeDamage(Attack)
		$AttackTimer.start(AttackTimer)


func _on_EnemyBod_body_exited(body):
	if body.is_in_group("player"):
		$AttackTimer.stop()
