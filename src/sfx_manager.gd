extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalHub.brick_hit.connect(_brick_hit)
	SignalHub.bumper_hit.connect(_bumper_hit)
	SignalHub.slingshot_hit.connect(_slingshot_hit)
	SignalHub.flipper_hit.connect(_ball_flipper)
	SignalHub.ball_lost.connect(_ball_lost)
	SignalHub.kickback_ejection.connect(_kickback_ejection)


func play_audio(audio_name: StringName, target_node: Node = null) -> void:
	var emitter = EventAudio.play_2d(audio_name, target_node)
	if emitter:
		emitter.player.bus = &"SFX"


func _brick_hit(_brick: Brick, _ball: Ball, destroyed: bool) -> void:
	play_audio(&"brick_destroyed" if destroyed else &"brick_hit", _brick)


func _slingshot_hit(_slingshot: Slingshot, _ball: Ball) -> void:
	play_audio(&"slingshot", _slingshot)


func _bumper_hit(bumper: Bumper, _ball: Ball) -> void:
	if bumper.score > 0:
		play_audio(&"bumper", bumper)
	else:
		play_audio(&"bumper_negative", bumper)


var _ball_wall_ts: int = 0

func _ball_wall(_ball: Ball, _wall: Node2D) -> void:
	var now = Time.get_ticks_msec()
	if _ball_wall_ts == 0 or (now - _ball_wall_ts) >= 250:
		play_audio(&"ball_wall", _ball)
		_ball_wall_ts = now

func _ball_flipper(flipper: Flipper, _ball: Ball) -> void:
	var now = Time.get_ticks_msec()
	if _ball_wall_ts == 0 or (now - _ball_wall_ts) >= 250:
		play_audio(&"ball_flipper", flipper)
		_ball_wall_ts = now


func _ball_lost(_ball: Ball) -> void:
	play_audio(&"ball_lost", _ball)


func _kickback_ejection(kickback: KickBack, _ball: PhysicsBody2D, _force: int) -> void:
	play_audio(&"kickback", kickback)
