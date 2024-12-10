class_name BallComponentPassThrough
extends BallComponent

const BIT: int = 1 << 4

var _modulate: Color


func _enter_tree() -> void:
	_ball.collision_mask &= ~BIT
	_modulate = _ball.modulate
	_ball.modulate = Color(2, 0.5, 0.5)


func _exit_tree() -> void:
	_ball.collision_mask |= BIT
	_ball.modulate = _modulate
