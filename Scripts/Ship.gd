extends Node2D

onready var Laser = preload("res://Scenes/PlayerLaser.tscn")
var laser_nodes :Node2D = null

export var speed = 750
var x_input : float = 0
var y_input : float = 0
var movement := Vector2()
var state = "def"
signal game_over
signal coin

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	move(delta)
	if !$Hitbox.active:
		$Sprite.self_modulate.a = rand_range(0.25,1)

func get_input():
	x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	y_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if Input.is_action_just_pressed("shoot") and $Hitbox.active:
		if $Ui/HealthBar.hp !=  $Ui/HealthBar.total_hp:
			shoot()
		else:
			supershoot()

func shoot():
	var laser = Laser.instance()
	if laser_nodes != null:
		laser_nodes.add_child(laser)
	laser.global_position = $SpawnLasersPos.global_position

func supershoot():
	var laser = Laser.instance()
	var laser2 = Laser.instance()
	var laser3 = Laser.instance()
	if laser_nodes != null:
		laser_nodes.add_child(laser)
		laser_nodes.add_child(laser2)
		laser_nodes.add_child(laser3)
	laser.global_position = $SpawnLasersPos.global_position
	laser2.global_position = Vector2($SpawnLasersPos.global_position.x, $SpawnLasersPos.global_position.y + 50)
	laser3.global_position = Vector2($SpawnLasersPos.global_position.x, $SpawnLasersPos.global_position.y - 50)

func move(delta):
	movement.x = x_input 
	movement.y = y_input 
	global_position += movement.normalized() * speed * delta
	global_position.x = clamp(global_position.x, 0, get_viewport_rect().size.x)
	global_position.y = clamp(global_position.y, 0, get_viewport_rect().size.y)


# warning-ignore:unused_argument
func damage(damage,potency,effect,k,r):
	$Hitbox.active = false
	$InmunityTimer.start()
	match effect:
		"":
			$Sounds/DamageSound.play()
			$Ui/HealthBar.hp -= damage
			get_tree().call_group("camerashake","shake",100,.5 * potency,100,Color.white)
			position += 3 * k
		"fire":
			$Sounds/DamageSoundFire.play()
			if rand_range(0,1) > 0.5:
				$Ui/HealthBar.hp -= damage + 1
			else:
				$Ui/HealthBar.hp -= damage + 2
			get_tree().call_group("camerashake","shake",200,.5 * potency,200,Color.orangered)
			$Sprite.modulate = Color.firebrick
			state = "fire"
			$EffectTimer.wait_time = .5
			$EffectTimer.start()
			position += 3 * k
		"ice":
			$Sounds/DamageSoundIce.play()
			$Ui/HealthBar.hp -= damage
			speed = 300
			get_tree().call_group("camerashake","shake",100,.8 * potency,75,Color.lightblue)
			$Sprite.modulate = Color.steelblue
			state = "ice"
			$EffectTimer.wait_time = 5
			$EffectTimer.start()
			position += 3 * k
		"venom":
			if state == "ice":
				speed = 750
			$Sounds/DamageSoundVenom.play()
			$Ui/HealthBar.hp -= damage
			get_tree().call_group("camerashake","shake",100,.5 * potency,70,Color.olivedrab)
			$Sprite.modulate = Color.darkolivegreen
			state = "venom"
			randomize()
			$EffectTimer.wait_time = int(rand_range(2,6))
			$EffectTimer.start()
			position += 3 * k

func _on_HealthBar_die():
	$Sounds/DeathSound.play()
	$Sprite.hide()
	$ExplodeParticles.emitting = true
	$Hitbox.active = false
	$DestroyEnemieHitbox.active = false
	if $InmunityTimer.time_left > 0:
		$InmunityTimer.stop()
	$DieTimer.start()

func _on_InmunityTimer_timeout():
	$Hitbox.active = true
	$Sprite.self_modulate.a = 1

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Hitbox_item_signal(item,effect,k,r):
	match item:
		"coin":
			emit_signal("coin",3)
			$Sounds/CoinSound.play()
		"bonus_coin":
			emit_signal("coin",5)
			$Sounds/CoinSound2.play()

func _on_EffectTimer_timeout():
	match state:
		"def":
			pass
		"ice":
			state = "def"
			speed = 750
		"venom":
			state = "def"
			damage(1,1,"",Vector2(0,0),true)
	$Sprite.modulate = Color.white


func _on_DieTimer_timeout():
	emit_signal("game_over")
	queue_free()


# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func heal(heal,effect,k,r):
	$Sounds/HealSound.play()
	$Ui/HealthBar.hp += heal
	get_tree().call_group("camerashake","shake",70,.2,70,Color.limegreen)
