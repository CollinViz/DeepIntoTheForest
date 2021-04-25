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
 
				
func _state_logic(_delta):
	match state:
		states.dodge:
			parent.reduce_Stamina(-5)
		states.dash:
			parent.reduce_Stamina(-10)
	

func _get_transition(_delta): 
	if state == states.dodge && parent.Is_Stamina_empty():
		return states.idle
	if state == states.dash && parent.Is_Stamina_empty():
		return states.idle
	return null 

func _enter_state(new_state,old_state):
	print("Player _enter_state new ",_stateName(new_state)," old ",_stateName(old_state))
	pass 
	 

func _exit_state(old_state,new_state):
	print("Player _exit_state old ",_stateName(old_state)," new ",_stateName(new_state))
	 
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
