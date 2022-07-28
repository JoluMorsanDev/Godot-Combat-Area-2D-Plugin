tool
extends EditorPlugin


func _enter_tree():
	ProjectSettings.set_setting("debug/shapes/collision/shape_color",Color(0.94,1,1,0.41))
	add_custom_type("CombatArea","Area2D",preload("res://addons/Combat_Area/CombatArea2D.gd"),preload("res://addons/Combat_Area/CombatArea2DIcon.png"))
	add_custom_type("HealthBar","TextureProgress",preload("res://addons/Combat_Area/HealthBar.gd"),preload("res://addons/Combat_Area/HealthBarIcon.png"))
	add_custom_type("ScreenShakeCamera","Camera2D",preload("res://addons/Combat_Area/ScreenShakeCamera.gd"),preload("res://addons/Combat_Area/CameraShakeIcon.png"))

func _exit_tree():
	ProjectSettings.set_setting("debug/shapes/collision/shape_color",Color(0,0.6,0.7,0.42))
	remove_custom_type("CombatArea")
	remove_custom_type("HealthBar")
	remove_custom_type("ScreenShakeCamera")
