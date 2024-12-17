extends Node

const POINTS := {
	&"brick": 1000
}

const SCORE_STEPS := {
	20_000: &"kickback",
	200_000: &"extraball"
}


#region Score
signal score_changed(score: int)
signal score_step_reached(steps: Array[StringName])

var score: int = 0:
	set(v):
		var steps = _get_reached_steps(score, v)
		score = max(0, v)
		if not steps.is_empty():
			score_step_reached.emit(steps)
		score_changed.emit(score)

var formatted_score: String:
	get: return TextServerManager.get_primary_interface().format_number(str(score))


static func _get_reached_steps(prev: int, next: int) -> Array[StringName]:
	var result: Array[StringName] = []
	if prev < next:
		var d1
		var d2
		for value in SCORE_STEPS:
			d1 = floori(prev / value)
			d2 = floori(next / value)
			if d1 != d2:
				result.append(SCORE_STEPS[value])
	return result
#endregion


#region Balls
signal game_over
signal ball_saver_changed(active: bool)

var _balls: int = 3

var ball_save_active: bool = true:
	set(v):
		ball_save_active = v
		ball_saver_changed.emit(ball_save_active)


func ball_lost() -> bool:
	if not ball_save_active:
		if _balls == 0:
			game_over.emit()
		else:
			_balls -= 1
		return false
	ball_save_active = false
	return true
#endregion


func brick_destroyed(brick: Brick) -> int:
	score += POINTS.brick
	return POINTS.brick


func reset() -> void:
	score = 0
	_balls = 3
	ball_save_active = true
