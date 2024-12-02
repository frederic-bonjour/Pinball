class_name PinballBoard
extends Node2D

@export var theme: BoardTheme

@onready var camera: Camera2D = %Camera
@onready var ball: Ball = %Ball
@onready var launcher: Node2D = %Launcher
@onready var launcher_rotate_on_flip: ComponentRotateOnFlip = $Launcher/RotateOnFlip


const BallBounceScene = preload("res://src/fx/ball_bounce_particles.tscn")

var _ball_initial_position: Vector2
var _score: int = 0:
	set(v):
		var d1 = floori(_score / 10_000)
		_score = v
		var d2 = floori(_score / 10_000)
		if d1 != d2:
			_score_step_reached()
		%ScoreLabel.text = TextServerManager.get_primary_interface().format_number(str(_score))


func _ready():
	_ball_initial_position = ball.position
	var t := get_tree()
	t.set_group(&"bricks", "modulate", theme.bricks_color)
	t.set_group(&"slingshots", "modulate", theme.slingshots_color)
	t.set_group(&"bumpers", "modulate", theme.bumpers_color)
	t.set_group(&"flippers", "modulate", theme.flippers_color)
	t.set_group(&"balls", "modulate", theme.balls_color)
	t.set_group(&"walls", "modulate", theme.walls_color)
	SignalHub.ball_touched_modular_wall.connect(_add_ball_touch_particles)
	SignalHub.ball_touched_wall.connect(_add_ball_touch_particles)
	SignalHub.ball_touched_flipper.connect(_add_ball_touch_particles)
	SignalHub.brick_destroyed.connect(_brick_destroyed)
	SignalHub.bumper_hit.connect(_bumper_hit)
	_activate_kickbacks()


func _process(delta: float):
	_process_inputs()
	_update_camera(delta)


func _process_inputs() -> void:
	var tree := get_tree()
	if Input.is_action_just_pressed(&"flipper_left"):
		tree.call_group(&"flipper_left", &"activate")
		tree.call_group(&"rotate_on_flip", &"rotate_left")
		SfxManager.play_audio(&"flipper_up")
	if Input.is_action_just_released(&"flipper_left"):
		tree.call_group(&"flipper_left", &"deactivate")
		SfxManager.play_audio(&"flipper_down")

	if Input.is_action_just_pressed(&"flipper_right"):
		tree.call_group(&"flipper_right", &"activate")
		tree.call_group(&"rotate_on_flip", &"rotate_right")
		SfxManager.play_audio(&"flipper_up")
	if Input.is_action_just_released(&"flipper_right"):
		tree.call_group(&"flipper_right", &"deactivate")
		SfxManager.play_audio(&"flipper_down")


var _camera_zoom = 0.75

func _update_camera(delta: float) -> void:
	camera.position = ball.position
	if Input.is_action_just_pressed(&"zoom_in"):
		_camera_zoom = 0.5
	elif Input.is_action_just_pressed(&"zoom_out"):
		_camera_zoom = 0.75
	var z = camera.zoom.x
	z = move_toward(z, _camera_zoom, delta)
	camera.zoom.x = z
	camera.zoom.y = z


func _on_lose_ball_area_body_entered(body: Node2D) -> void:
	if body is Ball:
		SignalHub.ball_lost.emit(body)
		# Stops the ball
		body.linear_velocity = Vector2.ZERO
		# Reset launcher to its default/central postion
		await launcher_rotate_on_flip.reset()
		# When launcher is ready, telepoty the ball into it.
		body.teleport_to(_ball_initial_position)
		_activate_kickbacks()


func _activate_kickbacks() -> void:
	get_tree().set_group(&"kickbacks", "inactive", false)


func _add_ball_touch_particles(_ball: Ball, _body: Node2D) -> void:
	var particles = BallBounceScene.instantiate()
	particles.top_level = true
	particles.position = _ball.global_position
	add_child(particles)


func _on_kick_back_ejection(_ball: PhysicsBody2D, kickback: KickBack, force: int):
	SignalHub.kickback_ejection.emit(_ball, kickback, force)


func _on_kickback_activation_area_body_entered(_body):
	_activate_kickbacks()


func _brick_destroyed(_brick: Brick, _ball) -> void:
	_score += 1000


func _bumper_hit(_bumper: Bumper, _ball) -> void:
	_score = max(0, _score + _bumper.score)


func _score_step_reached() -> void:
	_activate_kickbacks()


func _on_letter_group_letter_on(letter: IndicatorLetter):
	SfxManager.play_audio(&"letter_on", letter)


func _on_letter_group_kick_completed():
	_activate_kickbacks()


func _on_letter_group_save_completed():
	pass #TODO
