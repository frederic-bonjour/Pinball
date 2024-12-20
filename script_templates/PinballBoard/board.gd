extends PinballBoard

@onready var launcher: BallLauncher = $Launcher


func _board_ready():
	launcher.load_ball(new_ball())


func _board_ball_lost(ball: Ball):
	launcher.load_ball(ball)


func _on_ball_saver_changed(_active: bool) -> void:
	pass


func _board_on_letter_group_completed(_group: LetterIndicatorGroup, _ball: Ball):
	pass


func _is_board_complete() -> bool:
	return all_brick_groups_cleared
