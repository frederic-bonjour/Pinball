extends PinballBoard

@onready var launcher: LauncherPlot = $LauncherPlot


func _board_ready():
	_board_load_ball_in_launcher(new_ball())


func _board_load_ball_in_launcher(ball: Ball):
	await launcher.reset_position()
	launcher.load_ball(ball)


func _on_ball_saver_changed(_active: bool):
	pass


func _board_on_letter_group_completed(_group: LetterIndicatorGroup, _ball: Ball):
	pass


func _is_board_complete():
	return all_brick_groups_cleared


func _on_accelerator_body_entered(body):
	%BottomCenterBlocker.ball_can_pass_through = false
	%BottomCenterBlocker.visible = true


func _on_ball_teleporter_body_entered(body):
	%BottomCenterBlocker.ball_can_pass_through = true
	%BottomCenterBlocker.visible = false
