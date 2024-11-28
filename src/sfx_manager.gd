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


func _brick_touched(_brick: Brick, _ball: Ball) -> void:
	EventAudio.play_2d(&"brick_hit", _brick)


func _slingshot_bounce(_slingshot: Slingshot, _ball: Ball) -> void:
	EventAudio.play_2d(&"slingshot", _slingshot)


func _brick_destroyed(_brick: Brick, _ball: Ball) -> void:
	EventAudio.play_2d(&"brick_destroyed", _brick)


func _bumper_hit(_bumper: Bumper, _ball: Ball) -> void:
	EventAudio.play_2d(&"bumper", _bumper)


var _ball_wall_ts: int = 0
func _ball_wall(_ball: Ball, _wall: Node2D) -> void:
	var now = Time.get_ticks_msec()
	if _ball_wall_ts == 0 or (now - _ball_wall_ts) >= 100:
		EventAudio.play_2d(&"ball_wall", _ball)
		_ball_wall_ts = now


func _ball_flipper(_ball: Ball, _wall: Node2D) -> void:
	EventAudio.play_2d(&"ball_wall", _ball) #FIXME?


func _ball_lost(_ball: Ball) -> void:
	EventAudio.play_2d(&"ball_lost", _ball)
