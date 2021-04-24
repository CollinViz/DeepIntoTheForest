extends "res://Player/StateMachine.gd"



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_state("idle")
	add_state("shoot")
	add_state("hunt")
	add_state("hid")
	add_state("hit")
	#call_deferred("set_state",states.idle)
 
				
func _state_logic(_delta):
	if state==states.hunt:
		parent.FinedPlayer()
	
	

func _get_transition(_delta): 
	if state==states.hunt: #and !parent.is_in_Range()
		return states.shoot
	return null 

func _enter_state(new_state,old_state):
	print("_enter_state new ",_stateName(new_state)," old ",_stateName(old_state))
	 
	 

func _exit_state(old_state,new_state):
	print("_exit_state old ",_stateName(old_state)," new ",_stateName(new_state))
	 
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
