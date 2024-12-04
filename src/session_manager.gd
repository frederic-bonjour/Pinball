extends Node

signal score_changed(score: int)
signal score_step_reached(steps: Array[StringName])

const SCORE_STEPS := {
	20_000: &"kickback"
} 

var score: int = 0:
	set(v):
		var steps = _get_reached_steps(score, v)
		score = max(0, v)
		if not steps.is_empty():
			score_step_reached.emit(steps)
		score_changed.emit(score)

var formatted_score: String:
	get: return TextServerManager.get_primary_interface().format_number(str(score))


func reset() -> void:
	score = 0


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
