tool
extends Area2D

export var active = true

export(String, "Select one in list", "Player Hitbox","Player Projectile","Enemy Hitbox", "Enemie Projectile", "Coin", "Bomb", "Heal Pills","Heal Area", "Fireball") var template

export(String, "Body", "Heal", "Damage", "Item") var area_type
export var destroy_on_collision = false
export var damage = float(0)
export var heal = float(0)
export var potency = float(0)
export var item = ""
export var effect = ""
export var rotated_knockback = true
export(Vector2) var knocback_dir = Vector2(0,0)
export var team = int(1)


export var print_combat_info = false
#if you are modigying the script and want to simulate an enter tree, decoment this
#export var reload_propieties_devs = false


signal damage_signal(damage,potency,effect,knocback_dir,rotated_knockback)
signal heal_signal(heal,effect,knocback_dir,rotated_knockback)
signal item_signal(item,effect,knocback_dir,rotated_knockback)


func _enter_tree():
	reload()

func reload():
	if !is_connected("area_entered",self,"collide"):
		connect("area_entered",self,"collide")
	set_collision_layer_bit(0,false)
	set_collision_layer_bit(1,true)
	set_collision_mask_bit(0,false)
	set_collision_mask_bit(1,true)
	add_to_group("combat_area")

func collide(area:Area2D):
	if !Engine.editor_hint and active:
		if area_type != "Body" and area.is_in_group("combat_area_body"):
			if area.active:
				if area_type == "Damage" and area.team != team:
					area.damage_func(damage,potency,effect,knocback_dir,rotated_knockback)
					if destroy_on_collision:
						queue_free()
				if area_type == "Heal" and area.team == team:
					area.heal_func(heal,effect,knocback_dir,rotated_knockback)
					if destroy_on_collision:
						queue_free()
				if area_type == "Item" and area.team == team:
					area.item_func(item,effect,knocback_dir,rotated_knockback)
					if destroy_on_collision:
						queue_free()

func item_func(item,effect,knocback_dir,rotated_knockback):
	emit_signal("item_signal",item,effect,knocback_dir,rotated_knockback)

func damage_func(damage,potency,effect,knocback_dir,rotated_knockback):
	emit_signal("damage_signal",damage,potency,effect,knocback_dir,rotated_knockback)

func heal_func(heal,effect,knocback_dir,rotated_knockback):
	emit_signal("heal_signal",heal,effect,knocback_dir,rotated_knockback)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if area_type == "":
		area_type = "Body"
	monitorable = active
	monitoring = active
	add_to_group("combat_area")
	change_groups()
	change_to_template()
	if Engine.editor_hint:
		change_collision_color()
		print_info()
		#if you are modigying the script and want to simulate an enter tree, decoment this
		#if reload_propieties_devs:
		#	reload_propieties_devs = false
		#	reload()

func print_info():
	if print_combat_info == true:
		print_combat_info = false
		print(str(self.name) + " properties:")
		print(get_groups())
		print("Team " + str(team))
		if area_type == "Damage":
			print("Damage " + str(damage))
			print("Potency " + str(potency))
		if area_type == "Heal":
			print("Heal " + str(heal))
		if area_type == "Item":
			if item != "":
				print("Item: " + str(item))
			else:
				print("No item")
		if effect != "":
			print("Effect: " + str(effect))
		else:
			print("No effect")
		print("Knockback dir: " + str(knocback_dir))
		if rotated_knockback:
			print("Rotated Knockback")
		else:
			print("Fixed Knockback")
		if destroy_on_collision:
			print("Will destroy when collide")
		match area_type:
			"Damage":
				print("Damaging area")
			"Heal":
				print("Healing area")
			"Body":
				print("Body area")
			"Item":
				print("Item area")
		if active:
			print("active")
		else:
			print("inactive")

func change_collision_color():
	if get_node_or_null("CollisionShape2D") != null:
		if active:
			match area_type:
				"Damage":
					get_node_or_null("CollisionShape2D").modulate = Color.red
				"Heal":
					get_node_or_null("CollisionShape2D").modulate = Color.limegreen
				"Body":
					get_node_or_null("CollisionShape2D").modulate = Color.navyblue
				"Item":
					get_node_or_null("CollisionShape2D").modulate = Color.yellow
		else:
			get_node_or_null("CollisionShape2D").modulate = Color.transparent
	if get_node_or_null("CollisionPolygon2D") != null:
		if active:
			match area_type:
				"Damage":
					get_node_or_null("CollisionPolygon2D").modulate = Color.red
				"Heal":
					get_node_or_null("CollisionPolygon2D").modulate = Color.limegreen
				"Body":
					get_node_or_null("CollisionPolygon2D").modulate = Color.navyblue
				"Item":
					get_node_or_null("CollisionPolygon2D").modulate = Color.yellow
		else:
			get_node_or_null("CollisionPolygon2D").modulate = Color.transparent
	else:
		pass

func change_groups():
	if is_in_group("combat_area_null"):
		remove_from_group("combat_area_null")
	match area_type:
		"Damage":
			if !is_in_group("combat_area_damage"):
				add_to_group("combat_area_damage")
			if is_in_group("combat_area_heal"):
				remove_from_group("combat_area_heal")
			if is_in_group("combat_area_body"):
				remove_from_group("combat_area_body")
			if is_in_group("combat_area_item"):
				remove_from_group("combat_area_item")
		"Heal":
			if is_in_group("combat_area_damage"):
				remove_from_group("combat_area_damage")
			if !is_in_group("combat_area_heal"):
				add_to_group("combat_area_heal")
			if is_in_group("combat_area_body"):
				remove_from_group("combat_area_body")
			if is_in_group("combat_area_item"):
				remove_from_group("combat_area_item")
		"Body":
			if is_in_group("combat_area_damage"):
				remove_from_group("combat_area_damage")
			if is_in_group("combat_area_heal"):
				remove_from_group("combat_area_heal")
			if !is_in_group("combat_area_body"):
				add_to_group("combat_area_body")
			if is_in_group("combat_area_item"):
				remove_from_group("combat_area_item")
		"Item":
			if is_in_group("combat_area_damage"):
				remove_from_group("combat_area_damage")
			if is_in_group("combat_area_heal"):
				remove_from_group("combat_area_heal")
			if is_in_group("combat_area_body"):
				remove_from_group("combat_area_body")
			if !is_in_group("combat_area_item"):
				add_to_group("combat_area_item")

func change_to_template():
	match template:
		"Select one in list":
			pass
		"Player Hitbox":
			area_type = "Body"
			destroy_on_collision = false
			damage = 0
			heal = 0
			potency = 0
			item = ""
			effect = ""
			team = 1
			template = "Select one in list"
			property_list_changed_notify()
		"Player Projectile":
			area_type = "Damage"
			destroy_on_collision = true
			damage = 1
			heal = 0
			potency = 1
			item = ""
			effect = ""
			team = 1
			template = "Select one in list"
			property_list_changed_notify()
		"Enemy Hitbox":
			area_type = "Body"
			destroy_on_collision = false
			damage = 0
			heal = 0
			potency = 0
			item = ""
			effect = ""
			team = 2
			template = "Select one in list"
			property_list_changed_notify()
		"Enemie Projectile":
			area_type = "Damage"
			destroy_on_collision = true
			damage = 1
			heal = 0
			potency = 1
			item = ""
			effect = ""
			team = 2
			template = "Select one in list"
			property_list_changed_notify()
		"Coin":
			area_type = "Item"
			destroy_on_collision = true
			damage = 0
			heal = 0
			potency = 0
			item = "coin"
			effect = ""
			team = 1
			template = "Select one in list"
			property_list_changed_notify()
		"Bomb":
			area_type = "Damage"
			destroy_on_collision = true
			damage = 3
			heal = 0
			potency = 5
			item = ""
			effect = ""
			team = 3
			template = "Select one in list"
			property_list_changed_notify()
		"Heal Pills":
			area_type = "Item"
			destroy_on_collision = true
			damage = 0
			heal = 0
			potency = 0
			item = "heal pills"
			effect = "regeneration"
			team = 1
			template = "Select one in list"
			property_list_changed_notify()
		"Heal Area":
			area_type = "Heal"
			destroy_on_collision = false
			damage = 0
			heal = 1
			potency = 0
			item = ""
			effect = ""
			team = 1
			template = "Select one in list"
			property_list_changed_notify()
		"Fireball":
			area_type = "Damage"
			destroy_on_collision = true
			damage = 2
			heal = 0
			potency = 0
			item = ""
			effect = "burning"
			team = 2
			template = "Select one in list"
			property_list_changed_notify()
