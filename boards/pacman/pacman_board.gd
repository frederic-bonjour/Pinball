extends PinballBoard

@onready var launcher: BallLauncher = $Launcher

# Called when the node enters the scene tree for the first time.
func _board_ready():
	launcher.load_ball(new_ball())


func _board_ball_lost(ball: Ball):
	launcher.load_ball(ball)
