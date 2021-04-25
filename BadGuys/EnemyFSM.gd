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
	add_state("idleHunt")
	add_state("huntSeek")
	#call_deferred("set_state",states.idle)
 
				
func _state_logic(_delta):
	if state==states.hunt:
		parent.FinedPlayer()
	
	

func _get_transition(_delta): 
	if state==states.hunt: #and !parent.is_in_Range()
		return states.shoot
	if state==states.huntSeek:
		return parent.check_playerInArea()
	return null 

func _enter_state(new_state,old_state):
	print("Enemy _enter_state new ",_stateName(new_state)," old ",_stateName(old_state))
	parent.updateStatusText(_stateName(new_state)) 
	
	if new_state == states.idle:
		parent.clear_target()
	

	if new_state == states.idleHunt:
		parent.sleep_reHunt()

	if new_state == states.shoot:
		parent.can_start_Shooting()
func _exit_state(old_state,new_state):
	print("Enemy _exit_state old ",_stateName(old_state)," new ",_stateName(new_state))
	 
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
