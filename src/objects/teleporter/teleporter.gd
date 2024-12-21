extends Area2D

@export var destination: Vector2

var _enter_ts: int = 0
var _ball: Ball


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_ball_entered(ball):
	_enter_ts = Time.get_ticks_msec()
	_ball = ball
	_ball.linear_damp = 20
	_ball.angular_damp = 2
	var t := create_tween()
	t.tween_property(_ball, "scale", Vector2.ZERO, 0.5).set_delay(0.5)
	t.tween_callback(_teleport_ball)
	t.tween_property(_ball, "scale", Vector2(1.5, 1.5), 0.5).set_delay(0.5)
	t.tween_property(_ball, "scale", Vector2.ONE, 0.15)


func _teleport_ball() -> void:
	_ball.teleport_to(destination)
