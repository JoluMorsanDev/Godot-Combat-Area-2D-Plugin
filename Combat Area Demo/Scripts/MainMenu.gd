extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	$Ui/MaxScoreLabelGameOver.text = "Max Score: " + str(DataSingletone.max_score)


func _on_PlayButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Level.tscn")

func _on_EarseDataButton_pressed():
	DataSingletone.earse_data()

func _on_CloseButton_pressed():
	get_tree().quit()
