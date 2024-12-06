extends Node

signal bumper_hit(bumper: Bumper, ball: Ball)
signal brick_hit(brick: Brick, ball: Ball, destroyed: bool)
signal slingshot_hit(slingshot: Slingshot, ball: Ball)

signal wall_hit(wall: Node2D, ball: Ball)
signal flipper_hit(flipper: Flipper, ball: Ball)
signal ball_lost(ball: Ball)

#region Kickbacks
signal kickback_loading(kickback: KickBack, value: float)
signal kickback_ejection(kickback: KickBack, ball: PhysicsBody2D, force: int)
signal kickback_ball_entered(kickback: KickBack, ball: PhysicsBody2D)
#endregion

#region Letter groups
signal letter_group_letter_lit(identifier: StringName, letter: IndicatorLetter)
signal letter_group_completed(identifier: StringName, group_node: Node)
#endregion


func _ready() -> void:
	# This is to avoid GDScript warnings.
	bumper_hit.connect(_noop2)
	brick_hit.connect(_noop3)
	slingshot_hit.connect(_noop2)
	wall_hit.connect(_noop2)
	flipper_hit.connect(_noop2)
	ball_lost.connect(_noop1)

	kickback_ejection.connect(_noop3)
	kickback_loading.connect(_noop2)
	kickback_ball_entered.connect(_noop2)

	letter_group_completed.connect(_noop2)
	letter_group_letter_lit.connect(_noop2)


func _noop1(_arg1) -> void:
	pass

func _noop2(_arg1, _arg2) -> void:
	pass

func _noop3(_arg1, _arg2, _arg3) -> void:
	pass
