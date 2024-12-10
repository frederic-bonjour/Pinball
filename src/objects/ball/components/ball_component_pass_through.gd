class_name BallComponentPassThrough
extends BallComponent

const COLLISION_BIT: int = 1 << 4

var _modulate: Color


func _enter_tree() -> void:
	name = "PassThrough"
	_ball.collision_mask &= ~COLLISION_BIT
	_modulate = _ball.modulate
	_ball.modulate = Color(2, 0.5, 0.5)


func _exit_tree() -> void:
	_ball.collision_mask |= COLLISION_BIT
	_ball.modulate = _modulate
