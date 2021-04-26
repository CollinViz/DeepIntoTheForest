extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
 
# Called when the node enters the scene tree for the first time.
func _ready():
	 
	var shopItems = GameDb.getShopItems();
	setShopItem("BaseShopItem1",shopItems[0])
	setShopItem("BaseShopItem2",shopItems[1])
	setShopItem("BaseShopItem3",shopItems[2])

func setShopItem(NodeName:String,item:Dictionary)->void:
	var shopItem = get_parent().get_node(NodeName)
	shopItem.ItemName = item.name
	shopItem.ItemDescription = item.description
	shopItem.ItemCost = item.cost
	shopItem.ItemType = item.itemName


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
