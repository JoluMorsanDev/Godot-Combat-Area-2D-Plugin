extends Node2D

export var speed = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	global_position.x = 1100
	global_position.y = rand_range(50,550)
	speed = rand_range(speed - 250 ,speed + 100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x -= speed * delta 
	if get_node_or_null("Hitbox") == null:
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
