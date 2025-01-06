extends PinballBoard

@onready var launcher: BallLauncher = $Launcher
@onready var windows_floor3_ap: AnimationPlayer = %WindowsFloor3AP


func _board_ready():
	_board_load_ball_in_launcher(new_ball())


func _board_load_ball_in_launcher(ball: Ball):
	launcher.load_ball(ball)


func _on_ball_saver_changed(_active: bool):
	pass


func _board_process(delta: float) -> void:
	pass


func _board_on_letter_group_completed(group: LetterIndicatorGroup, _ball: Ball):
	match group.letters:
		&"MOON": $Moon.rise()
		&"LIGHTS": windows_floor3_ap.play(&"completed")


func _is_board_complete():
	return all_brick_groups_cleared


func _on_ghost_brick_hit_in_group(_group_name):
	var t := create_tween()
	t.tween_property($Ghost, "modulate:a", 0.2, 0.2).from(1.0)
