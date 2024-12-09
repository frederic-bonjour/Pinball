class_name BallComponentPassThrough
extends BallComponent

const BIT: int = 1 << 4

func _component_added():
	_ball = get_parent()
	_ball.collision_mask &= ~BIT

func _component_removed():
	_ball.collision_mask |= BIT
