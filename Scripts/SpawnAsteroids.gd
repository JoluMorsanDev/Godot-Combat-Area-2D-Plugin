extends Node2D

onready var Asteroid = preload("res://Scenes/Asteroid.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	$Diffcultween.interpolate_property($SpawnAsteroidsTimer,"wait_time",0.8,0.1,45)
	$Diffcultween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnAsteroidsTimer_timeout():
	var asteorid = Asteroid.instance()
	asteorid.global_position = Vector2(-1024,-600)
	asteorid.connect("destroyed",owner,"add_score")
	$Asteroids.add_child(asteorid)
