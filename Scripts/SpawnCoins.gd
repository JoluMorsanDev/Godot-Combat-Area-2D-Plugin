extends Node2D

onready var Coin = preload("res://Scenes/Coin.tscn")
onready var Heal = preload("res://Scenes/HealItem.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$SpawnCoinsTimer.wait_time = rand_range(3,6)
	$SpawnCoinsTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnCoinsTimer_timeout():
	var coin = Coin.instance()
	coin.global_position = Vector2(-1024,-600)
	$Coins.add_child(coin)
	$SpawnCoinsTimer.wait_time = rand_range(3,6)
	$SpawnCoinsTimer.start()


func _on_Healtimer_timeout():
	var heal = Heal.instance()
	heal.global_position = Vector2(-1024,-600)
	$Coins.add_child(heal)
