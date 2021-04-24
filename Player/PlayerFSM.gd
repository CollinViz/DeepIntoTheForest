extends "res://Player/StateMachine.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_state("idle")
	add_state("shoot")
	add_state("dodge")
	add_state("dash")
	add_state("hit")
	#call_deferred("set_state",states.idle)
 
				
func _state_logic(delta):
	if !parent.checkDestination():
		return

	if state == states.flyTo || state == states.flyback || state == states.flySatellite:
		parent.move_to_destination(delta)

	if state == states.drill || state == states.makeSatellite:
		parent.stick_to(delta)

func _get_transition(_delta):
	match state:
		states.flyTo:
			if parent.hasArrived():
				return states.drill
		states.flyback:
			if parent.hasArrived():
				return states.deliver
		states.flySatellite:
			if parent.hasArrived():
				parent.play_make_satelliteAni()
				#yield(get_tree().create_timer(2.9), "timeout")
				 
		states.makeSatellite:
			parent.SatelliteVisible()

	return null 

func _enter_state(new_state,old_state):
	print("_enter_state new ",_stateName(new_state)," old ",_stateName(old_state))
	if new_state == states.drill:
		parent.drone_land()
	if new_state == states.deliver:
		parent.drone_delivered()

func _exit_state(old_state,new_state):
	print("_exit_state old ",_stateName(old_state)," new ",_stateName(new_state))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
