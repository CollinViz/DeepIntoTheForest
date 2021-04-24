extends Node
const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0
var piroity = 0

onready var camera = get_parent()

func start(duration=0.2,frequency=15,amplitudein=5,piroityin=0):
	if piroityin>=self.piroity:
		self.amplitude= amplitudein
		self.piroity = piroityin
		$duration.wait_time = duration
		$frequency.wait_time = 1/ float(frequency)

		$duration.start()
		$frequency.start()

		_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude,amplitude)
	rand.y = rand_range(-amplitude,amplitude)

	$shake_tween.interpolate_property(camera,"offset",camera.offset,rand,$frequency.wait_time,TRANS,EASE)
	$shake_tween.start()

func _rest():
	self.piroity=0
	$shake_tween.interpolate_property(camera,"offset",camera.offset,Vector2(),$frequency.wait_time,TRANS,EASE)
	$shake_tween.start()

func _on_frequency_timeout():
	_new_shake()


func _on_duration_timeout():
	_rest()
	$frequency.stop()
	$duration.start()
