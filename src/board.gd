class_name PinballBoard
extends Node2D

@export var theme: BoardTheme

@onready var camera: Camera2D = %Camera
@onready var ball: Ball = %Ball


const BallBounceScene = preload("res://src/fx/ball_bounce_particles.tscn")

var _ball_initial_position: Vector2


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
		body.teleport_to(_ball_initial_position)


func _add_ball_touch_particles(_ball: Ball, _body: Node2D) -> void:
	var particles = BallBounceScene.instantiate()
	particles.top_level = true
	particles.position = _ball.global_position
	add_child(particles)


func _on_kick_back_ejection(_ball: PhysicsBody2D, kickback: KickBack, force: int):
	SignalHub.kickback_ejection.emit(_ball, kickback, force)
