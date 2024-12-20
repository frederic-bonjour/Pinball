extends PinballBoard

@onready var launcher: BallLauncher = $Launcher

# Called when the node enters the scene tree for the first time.
func _board_ready():
	_board_load_ball_in_launcher(new_ball())


func _board_load_ball_in_launcher(ball: Ball):
	launcher.load_ball(ball)
