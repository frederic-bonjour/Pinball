class_name BallComponentPassThrough
extends BallComponent

const BIT: int = 1 << 4
var _modulate: Color

func _component_added():
	_ball = get_parent()
	_ball.collision_mask &= ~BIT
	_modulate = _ball.modulate
	_ball.modulate = Color(2, 0.5, 0.5)

func _component_removed():
	_ball.collision_mask |= BIT
	_ball.modulate = _modulate
