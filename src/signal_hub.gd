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
