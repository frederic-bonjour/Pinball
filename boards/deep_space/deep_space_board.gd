extends PinballBoard


@onready var launcher_plot: LauncherPlot = $LauncherPlot


func _board_ready() -> void:
	launcher_plot.load_ball(new_ball())


func _board_ball_lost(ball: Ball):
	await launcher_plot.reset_position()
	launcher_plot.load_ball(ball)
