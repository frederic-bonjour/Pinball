class_name BallComponentExplosive
extends BallComponent

const BIT: int = 1 << 4

var _modulate: Color


func _component_added():
	_ball = get_parent()
	_ball.collision_mask &= ~BIT
	_modulate = _ball.modulate
	_ball.modulate = Color(2, 0.5, 0.5)
	SignalHub.brick_hit.connect(_on_brick_hit)


func _on_brick_hit(brick: Brick, ball: Ball, destroyed: bool) -> void:
	if ball == _ball: # Only for the parent ball
		print("brick hit ", brick)
		# TODO search for bricks around (with a raycast) and destroyed them


func _component_removed():
	_ball.collision_mask |= BIT
	_ball.modulate = _modulate
