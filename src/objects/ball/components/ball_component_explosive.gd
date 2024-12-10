class_name BallComponentExplosive
extends BallComponent

const BIT: int = 1 << 4

var _modulate: Color


func _enter_tree() -> void:
	_ball = get_parent()
	_ball.collision_mask &= ~BIT
	_modulate = _ball.modulate
	_ball.modulate = Color(2, 0.5, 0.5)
	_ball.connect(&"touched_brick", _on_brick_hit)


func _exit_tree() -> void:
	_ball.modulate = _modulate


func _on_brick_hit(brick: Brick, destroyed: bool) -> void:
	print("brick hit ", brick)
	# TODO search for bricks around (with a raycast) and destroyed them
