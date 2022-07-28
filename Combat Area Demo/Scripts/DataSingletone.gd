extends Node

var max_score = 0
var max_score_file = "user://highscore.save"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_hs()

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.set_window_fullscreen(!OS.window_fullscreen)

func load_hs():
	var file = File.new()
	if file.file_exists(max_score_file):
		file.open(max_score_file,File.READ)
		max_score = file.get_var()
		file.close()
	else:
		max_score = 0

func set_hs(score):
	if score > max_score:
		max_score = score
		save_hs()

func save_hs():
	var file = File.new()
	file.open(max_score_file,File.WRITE)
	file.store_var(max_score)
	file.close()

func earse_data():
	var file = File.new()
	file.open(max_score_file, File.WRITE)
	file.store_var(0)
	file.close()
	get_tree().quit()
