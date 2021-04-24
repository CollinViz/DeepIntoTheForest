extends KinematicBody2D
export (PackedScene) var Bullet
export var speed = 200  # speed in pixels/sec

var velocity = Vector2.ZERO

onready var target = $Target
onready var muzzel = $Target/Sprite2
onready var muzzel2 = $muzzel
onready var HeathSystem = $HeathSystemView

func _ready():
	pass

func _input(event):
	if Input.is_action_just_pressed("shoot"):
			shoot()
		
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

	velocity = velocity.normalized() * speed
	
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	target.look_at(get_global_mouse_position())
	
	muzzel2.position = $Sprite.position + Vector2(cos(target.rotation), sin(target.rotation)) * 50

func shoot():
	var b = Bullet.instance()
	 
	b.transform = target.transform.scaled(Vector2(0.15,0.15)) 
	b.position = muzzel2.position
	 
	add_child(b)
