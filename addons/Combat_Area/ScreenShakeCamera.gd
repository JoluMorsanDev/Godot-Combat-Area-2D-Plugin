tool
extends Camera2D

onready var tween : Tween = null
onready var shakeTimer : Timer = null
onready var screen_color : ColorRect = null

export var shake_amount = 0
var default_offset = offset

func _enter_tree():
	reload()

func reload():
	if !is_in_group("camerashake"):
		add_to_group("camerashake")

func _ready():
	if !Engine.editor_hint:
		set_process_mode(false)
		if shakeTimer == null and tween == null:
			var ShakeTimer := Timer.new()
			var Tweenvar := Tween.new()
			var ScreenColor := ColorRect.new()
			add_child(ScreenColor)
			add_child(Tweenvar)
			add_child(ShakeTimer)
			ScreenColor.name = "Color"
			Tweenvar.name = "Tween"
			ShakeTimer.name = "Timer"
			tween = get_node("Tween")
			screen_color = get_node("Color")
			shakeTimer = get_node("Timer")
			screen_color.visible = false
			screen_color.rect_size = get_viewport_rect().size * 8000000000
			screen_color.rect_global_position = -screen_color.rect_size*.5
			shakeTimer.wait_time = 1
			shakeTimer.connect("timeout",self,"_on_Timer_timeout")

func _process(delta):
	if !Engine.editor_hint:
		randomize()
		offset = Vector2(rand_range(-shake_amount,shake_amount),rand_range(-shake_amount,shake_amount)) * delta + default_offset

func shake(new_shake,shake_time = 0.4,shake_limit = 100,color = Color.transparent,colored := true):
	if !Engine.editor_hint:
		screen_color.color = color
		if colored:
			screen_color.color.a = 0.1
		else:
			screen_color.color.a = 0
		screen_color.show()
		shake_amount += new_shake
		if shake_amount > shake_limit:
			shake_amount = shake_limit
	
		shakeTimer.wait_time = shake_time
	
		tween.stop_all()
		set_process_mode(true)
		shakeTimer.start()


func _on_Timer_timeout():
	if !Engine.editor_hint:
		screen_color.hide()
		shake_amount = 0
		set_process_mode(false)
		tween.interpolate_property(self, "offset", offset, default_offset, 0.1, Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		tween.start()
