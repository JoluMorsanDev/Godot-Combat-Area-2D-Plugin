extends Node2D

onready var Bullet = $PlayerLaser
var speed = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x += speed * delta
	if get_node_or_null("PlayerLaser") == null:
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
