extends Node

#region Hits
@warning_ignore("unused_signal")
signal bumper_hit(bumper: Bumper, ball: Ball)
@warning_ignore("unused_signal")
signal brick_hit(brick: Brick, ball: Ball, destroyed: bool)
@warning_ignore("unused_signal")
signal slingshot_hit(slingshot: Slingshot, ball: Ball)
@warning_ignore("unused_signal")
signal wall_hit(wall: Node2D, ball: Ball)
@warning_ignore("unused_signal")
signal flipper_hit(flipper: Flipper, ball: Ball)
#endregion

#region Kickbacks
@warning_ignore("unused_signal")
signal kickback_loading(kickback: KickBack, value: float)
@warning_ignore("unused_signal")
signal kickback_ejection(kickback: KickBack, ball: PhysicsBody2D, force: int)
@warning_ignore("unused_signal")
signal kickback_ball_entered(kickback: KickBack, ball: PhysicsBody2D)
#endregion

#region Letter groups
@warning_ignore("unused_signal")
signal letter_group_letter_lit(group_node: LetterIndicatorGroup, letter: IndicatorLetter)
@warning_ignore("unused_signal")
signal letter_group_completed(group_node: LetterIndicatorGroup, ball: Ball)
#endregion

@warning_ignore("unused_signal")
signal brick_group_cleared(group: BrickGroup)

@warning_ignore("unused_signal")
signal ball_lost(ball: Ball)
