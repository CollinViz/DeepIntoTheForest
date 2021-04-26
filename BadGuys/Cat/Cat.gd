extends "res://BadGuys/BaseBadGuy.gd"
var fireState:=0

 
func _takeDamage():
	print("Cat Take damage")
	if MaxHP<75 and MaxHP>50 and fireState==0:
		AttackTimer = 0.8
		rotate_speed=50
		spawn_pont_count=6
		radius=90
		on_ready_shooter()
		fireState=1
	if MaxHP<49 and MaxHP>25 and fireState==1:
		AttackTimer = 0.5
		rotate_speed=50
		spawn_pont_count=8
		radius=90
		on_ready_shooter()
		fireState=2
