extends Area2D


var speed = 1250

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()