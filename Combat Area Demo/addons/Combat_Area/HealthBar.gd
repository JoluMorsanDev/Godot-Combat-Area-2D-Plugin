tool
extends TextureProgress

export (int) var total_hp = 100
export var hp = 100
export var inverse = false
export var event_1 = false
export var event_1_hp = float()
export var event_2 = false
export var event_2_hp = float()
export var event_3 = false
export var event_3_hp = float()

signal die
signal event1
signal event2
signal event3

func _enter_tree():
	reload()

func reload():
	if !is_connected("value_changed",self,"change_value"):
		connect("value_changed",self,"change_value")

func damaging(damage):
	match inverse:
		false:
			hp -= damage
		true:
			hp += damage

func healing(heal):
	match inverse:
		false:
			hp += heal
		true:
			hp -= heal

func change_value(value):
	if !Engine.editor_hint:
		match inverse:
			false:
				if hp <= 0:
					emit_signal("die")
			true:
				if hp >= total_hp:
					emit_signal("die")
		if event_1 and hp == event_1_hp:
			emit_signal("event1")
		if event_2 and hp == event_2_hp:
			emit_signal("event2")
		if event_3 and hp == event_3_hp:
			emit_signal("event3")

func _process(delta):
	min_value = 0
	max_value = total_hp
	value = hp
	hp = clamp(hp,0,total_hp)
