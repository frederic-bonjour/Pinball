extends PinballBoard

@onready var launcher_plot: LauncherPlot = $LauncherPlot


func _board_ready() -> void:
	_board_load_ball_in_launcher(new_ball())


func _board_load_ball_in_launcher(ball: Ball):
	await launcher_plot.reset_position()
	launcher_plot.load_ball(ball)
