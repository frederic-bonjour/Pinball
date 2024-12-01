extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalHub.brick_destroyed.connect(_brick_destroyed)
	SignalHub.brick_touched.connect(_brick_touched)
	SignalHub.bumper_hit.connect(_bumper_hit)
	SignalHub.slingshot_bounce.connect(_slingshot_bounce)
	SignalHub.ball_touched_modular_wall.connect(_ball_wall)
	SignalHub.ball_touched_flipper.connect(_ball_flipper)
	SignalHub.ball_lost.connect(_ball_lost)
	SignalHub.kickback_ejection.connect(_kickback_ejection)


func play_audio(audio_name: StringName, target_node: Node2D = null) -> void:
	var emitter = EventAudio.play_2d(audio_name, target_node)
	if emitter:
		emitter.player.bus = &"SFX"


func _brick_touched(_brick: Brick, _ball: Ball) -> void:
	play_audio(&"brick_hit", _brick)


func _slingshot_bounce(_slingshot: Slingshot, _ball: Ball) -> void:
	play_audio(&"slingshot", _slingshot)


func _brick_destroyed(_brick: Brick, _ball: Ball) -> void:
	play_audio(&"brick_destroyed", _brick)


func _bumper_hit(_bumper: Bumper, _ball: Ball) -> void:
	play_audio(&"bumper", _bumper)


var _ball_wall_ts: int = 0

func _ball_wall(_ball: Ball, _wall: Node2D) -> void:
	var now = Time.get_ticks_msec()
	if _ball_wall_ts == 0 or (now - _ball_wall_ts) >= 250:
		play_audio(&"ball_wall", _ball)
		_ball_wall_ts = now

func _ball_flipper(_ball: Ball, _flipper: Flipper) -> void:
	var now = Time.get_ticks_msec()
	if _ball_wall_ts == 0 or (now - _ball_wall_ts) >= 250:
		play_audio(&"ball_flipper", _ball)
		_ball_wall_ts = now


func _ball_lost(_ball: Ball) -> void:
	play_audio(&"ball_lost", _ball)


func _kickback_ejection(_ball: PhysicsBody2D, kickback: KickBack, _force: int) -> void:
	play_audio(&"kickback", kickback)
