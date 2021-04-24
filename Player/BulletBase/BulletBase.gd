extends Area2D

var TotalDamage:int=0
var _BullerName:String = ""
var speed = 1250

func _physics_process(delta):
	position += transform.x * speed * delta

func setDamage(BaseDamage:int,WeaponMaxDamage:int,BulletName:String,BulletSpeed)->void:
	TotalDamage = BaseDamage + randi()%WeaponMaxDamage
	_BullerName  = BulletName
	speed = BulletSpeed

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.call_deferred("takeDamage",TotalDamage)
		
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
