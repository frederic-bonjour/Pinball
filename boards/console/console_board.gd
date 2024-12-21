extends PinballBoard

@onready var launcher_plot: LauncherPlot = $LauncherPlot


func _board_ready() -> void:
	_board_load_ball_in_launcher(new_ball())


func _board_load_ball_in_launcher(ball: Ball):
	await launcher_plot.reset_position()
	launcher_plot.load_ball(ball)


func _on_ball_saver_changed(_active: bool):
	pass


func _board_on_letter_group_completed(group: LetterIndicatorGroup, _ball: Ball):
	# On this board, activate the kickbacks everytime a group is completed.
	_activate_kickbacks()
	match group.letters:
		&"ACTIVATE":
			%Computer.activated = true
		&"BACKUP":
			SessionManager.ball_save_active = true
			%Computer.backup_done = true


func _is_board_complete():
	return all_brick_groups_cleared and %Computer.is_complete


func _on_cursor_brick_touched(brick: Brick):
	brick.update_scale(Vector2(-0.2, 0))


func _on_power_on_brick_touched(_brick):
	%Computer.started = true
