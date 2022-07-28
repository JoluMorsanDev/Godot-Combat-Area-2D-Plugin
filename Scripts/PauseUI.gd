extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PauseButton_toggled(button_pressed):
	if !button_pressed:
		get_tree().paused = false
		$RestartButton.hide()
		$ExitButton.hide()
	else:
		get_tree().paused = true
		$RestartButton.show()
		$ExitButton.show()

func _on_RestartButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func _on_ExitButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
