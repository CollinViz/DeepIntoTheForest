extends Node2D
 
const MIN_X =  10.0
const MAX_X = 50.0
const MIN_Y = -20.0
const MAX_Y =  80.0

func _ready():
	randomize()
#(PackedScene)
func createItems(ItemsList:Array): 
	var coins = []

	for i in ItemsList:
		var itm = i.instance()
		itm.position = Vector2.ZERO
		add_child(itm)
		coins.append(itm)

	var tween = Tween.new()
	add_child(tween)

	for coin in coins:
		var direction = 1 if randi() % 2 == 0 else -1
		var goal = coin.position + Vector2(rand_range(MIN_X, MAX_X), rand_range(MIN_Y, MAX_Y)) * direction

		tween.interpolate_property(coin, "position:x", null, goal.x, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.interpolate_property(coin, "position:y", null, goal.y - 50, 0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.interpolate_property(coin, "position:y", goal.y - 50, goal.y, 0.4, Tween.TRANS_QUAD, Tween.EASE_IN, 0.4)
		tween.interpolate_property(coin, "position:y", goal.y, goal.y - 10, 0.1, Tween.TRANS_QUAD, Tween.EASE_IN, 0.8)
		tween.interpolate_property(coin, "position:y", goal.y - 10, goal.y, 0.1, Tween.TRANS_QUAD, Tween.EASE_IN, 0.9)

	tween.start()

func _process(delta):
	pass


func _on_Timer_timeout():
	queue_free()
