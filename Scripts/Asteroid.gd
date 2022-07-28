extends Node2D

var rot_dir = 1
export var rot_speed = 50
var speed = 50
export(int,"Normal","Fire","Ice","Venom") var type

signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if rand_range(0,1) > 0.5:
		rot_dir = 1
	else:
		rot_dir = -1
	global_position.x = 1100
	global_position.y = rand_range(0,600)
	speed = rand_range(150,600)
	randomize_state()

func randomize_state():
	if rand_range(0,1) < 0.6:
		type = 0
	else:
		type = (randi() % 3) + 1
	match type:
		0:
			$Sprite.modulate = Color.gray
			$DamageHitbox.effect = ""
		1:
			$Sprite.modulate = Color.firebrick
			$DamageHitbox.effect = "fire"
		2:
			$Sprite.modulate = Color.steelblue
			$DamageHitbox.effect = "ice"
		3:
			$Sprite.modulate = Color.darkolivegreen
			$DamageHitbox.effect = "venom"
	$ExplodeParticles.modulate = $Sprite.modulate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x -= speed * delta 
	global_rotation_degrees += rot_dir * rot_speed * delta * (speed / 75)
	$VisibilityNotifier2D.global_rotation_degrees = 0

# warning-ignore:unused_argument
func _on_Hitbox_damage_signal(damage,potency,effect):
	if effect == "laser":
		get_tree().call_group("camerashake","shake",100,.3 * potency,75,Color.white,false)
	$DieSound.play()
	$Sprite.hide()
	$ExplodeParticles.emitting = true
	$Hitbox.active = false
	$DamageHitbox.active = false
	$DieTimer.start()
	match type:
		0:
			emit_signal("destroyed",1)
		1:
			emit_signal("destroyed",2)
		2:
			emit_signal("destroyed",2)
		3:
			emit_signal("destroyed",2)

func _on_DieTimer_timeout():
	queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	$Hitbox.active = true


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
