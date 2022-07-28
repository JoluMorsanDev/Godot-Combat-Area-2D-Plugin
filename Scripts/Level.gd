extends Node2D

var score = int(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	$Level/Ship.laser_nodes = $Level/Projectiles


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	$Ui/ScoreLabel.text = "Score: " + str(score)


func add_score(amount):
	score += amount

func _on_Ship_game_over():
	DataSingletone.set_hs(score)
	$Ui/ScoreLabelGameOver.text = "Score: " + str(score)
	$Ui/MaxScoreLabelGameOver.text = "Max Score: " + str(DataSingletone.max_score)
	$Level/CoverScreen.show()
	$Ui/ScoreLabel.hide()
	$Ui/ScoreLabelGameOver.show()
	$Ui/MaxScoreLabelGameOver.show()
	$PauseUI/PauseButton.hide()
	$PauseUI/ExitButton.show()
	$PauseUI/RestartButton.show()
