extends Node

signal bumper_hit(bumper: Bumper, ball: Ball)
signal brick_touched(brick: Brick, ball: Ball)
signal brick_destroyed(brick: Brick, ball: Ball)
signal slingshot_bounce(slingshot: Slingshot, ball: Ball)

signal ball_touched_modular_wall(ball: Ball, wall: ModularWall)
signal ball_touched_wall(ball: Ball, wall: Node2D)
signal ball_touched_flipper(ball: Ball, flipper: Flipper)
signal ball_lost(ball: Ball)

signal kickback_ejection(ball: PhysicsBody2D, kickback: KickBack, force: int)

func _ready() -> void:
	# This is to avoid GDScript warnings.
	bumper_hit.connect(_noop2)
	brick_touched.connect(_noop2)
	brick_destroyed.connect(_noop2)
	slingshot_bounce.connect(_noop2)
	ball_touched_modular_wall.connect(_noop2)
	ball_touched_wall.connect(_noop2)
	ball_touched_flipper.connect(_noop2)
	ball_lost.connect(_noop1)
	kickback_ejection.connect(_noop3)


func _noop1(_arg1) -> void:
	pass

func _noop2(_arg1, _arg2) -> void:
	pass

func _noop3(_arg1, _arg2, _arg3) -> void:
	pass
