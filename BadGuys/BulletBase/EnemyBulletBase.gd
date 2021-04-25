extends Area2D
var TotalDamage:int=0
var _BullerName:String = ""
var speed = 1250
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setDamage(BaseDamage:int,WeaponMaxDamage:int,BulletName:String,BulletSpeed)->void:
	TotalDamage = BaseDamage + randi()%WeaponMaxDamage
	_BullerName  = BulletName
	speed = BulletSpeed

func _physics_process(delta):
	#self.rotate(0.1)
	#self.position+=Vector2(bulletSpeed).rotated(bulletRotate)
	position+=transform.x * speed * delta
	 
	#self.rotate(deg2rad(bulletRotate))
	
	#bulletRotate+=30
	#bulletRotate =clamp(bulletRotate,0,360)
	#if bulletRotate>=360:
	#	bulletRotate=0



func _on_bullet_body_entered(body):
	if body.is_in_group("player"):
		body.call_deferred("takeDamage",TotalDamage)
		
	queue_free()
