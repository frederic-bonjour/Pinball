extends PinballBoard

@onready var launcher: BallLauncher = $Launcher


var _moon_position: float
var _moon_initial_position: float


func _board_ready():
	_board_load_ball_in_launcher(new_ball())
	_moon_initial_position = $Moon.position.y
	_moon_position = _moon_initial_position


func _board_load_ball_in_launcher(ball: Ball):
	launcher.load_ball(ball)


func _on_ball_saver_changed(_active: bool):
	pass


func _board_process(delta: float) -> void:
	if $Moon.position.y > -1200:
		var mp = $Moon.position.y
		$Moon.position.y = move_toward($Moon.position.y, _moon_position, delta * 5)
		if mp != $Moon.position.y:
			var s = remap($Moon.position.y, -1200, _moon_initial_position, 1.4, 1.0)
			$Moon.scale = Vector2(s, s)
	


func _board_on_letter_group_completed(group: LetterIndicatorGroup, _ball: Ball):
	match group.letters:
		&"MOON":
			_moon_position -= 10


func _is_board_complete():
	return all_brick_groups_cleared


func _on_ghost_brick_hit_in_group(_group_name):
	var t := create_tween()
	t.tween_property($Ghost, "modulate:a", 0.2, 0.2).from(1.0)
