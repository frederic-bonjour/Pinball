class_name PinballBoard
extends Control

@export var board_theme: BoardTheme

@onready var camera: Camera2D = %Camera
@onready var launcher: Node2D = %Launcher
@onready var launcher_rotate_on_flip: ComponentRotateOnFlip = %Launcher/RotateOnFlip
@onready var effects: Control = %Effects


const BallBounceScene = preload("res://src/fx/ball_bounce_particles.tscn")
const BrickExplosionScene = preload("res://src/fx/brick_explosion.tscn")

var _ball_initial_position: Vector2
var _camera_zoom = 0.5


func _ready():
	_ball_initial_position = launcher.global_position - Vector2(0, 60)

	var t := get_tree()
	t.set_group(&"bricks", "modulate", board_theme.bricks_color)
	t.set_group(&"slingshots", "modulate", board_theme.slingshots_color)
	t.set_group(&"bumpers", "modulate", board_theme.bumpers_color)
	t.set_group(&"flippers", "modulate", board_theme.flippers_color)
	t.set_group(&"balls", "modulate", board_theme.balls_color)
	t.set_group(&"walls", "modulate", board_theme.walls_color)

	SignalHub.wall_hit.connect(_add_ball_touch_particles)
	SignalHub.flipper_hit.connect(_add_ball_touch_particles)
	SignalHub.slingshot_hit.connect(_slingshot_hit)
	SignalHub.brick_hit.connect(_brick_hit)
	SignalHub.bumper_hit.connect(_bumper_hit)
	SignalHub.kickback_ejection.connect(_kick_back_ejection)
	SessionManager.connect(&"score_changed", _update_score)
	SessionManager.connect(&"score_step_reached", _on_score_steps_reached)

	SignalHub.connect(&"letter_group_completed", _on_letter_group_completed)
	SignalHub.connect(&"letter_group_letter_lit", _on_letter_group_letter_lit)

	_activate_kickbacks()


func _update_score(_score: int) -> void:
	%ScoreLabel.text = SessionManager.formatted_score


func _on_score_steps_reached(steps: Array[StringName]) -> void:
	if steps.has(&"kickback"):
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


func _update_camera(delta: float) -> void:
	var balls = get_tree().get_nodes_in_group(&"balls")
	if balls.size() == 1:
		camera.position = balls[0].position
		if Input.is_action_just_pressed(&"zoom_in"):
			_camera_zoom = 0.5
		elif Input.is_action_just_pressed(&"zoom_out"):
			_camera_zoom = 0.75
	else:
		_camera_zoom = 0.5

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


func _add_ball_touch_particles(_body: Node2D, _ball: Ball) -> void:
	var particles = BallBounceScene.instantiate()
	particles.top_level = true
	particles.position = _ball.global_position
	effects.add_child(particles)


func _kick_back_ejection(kickback: KickBack, _ball: PhysicsBody2D, _force: int):
	SessionManager.score += 100 #FIXME
	effects.add_child(VanishingTooltip.make_int(100, kickback))


func _on_kickback_activation_area_body_entered(_body):
	_activate_kickbacks()


func _brick_hit(brick: Brick, _ball, destroyed: bool) -> void:
	if destroyed:
		var expl = BrickExplosionScene.instantiate()
		expl.position = brick.global_position
		expl.color = brick.modulate
		add_child(expl)

		var points = SessionManager.brick_destroyed(brick)
		effects.add_child(VanishingTooltip.make_int(points, brick).offset_y(brick.size.y / 2))


func _bumper_hit(bumper: Bumper, _ball) -> void:
	SessionManager.score += bumper.score
	effects.add_child(VanishingTooltip.make_int(bumper.score, bumper).offset_y(-50))


func _slingshot_hit(_slingshot: Slingshot, ball: Ball) -> void:
	SessionManager.score += 50 #FIXME
	effects.add_child(VanishingTooltip.make_int(50, ball))


func _on_letter_group_letter_lit(_group_id: StringName, letter: IndicatorLetter):
	SfxManager.play_audio(&"letter_on", letter)
	SessionManager.score += 500 #FIXME
	effects.add_child(VanishingTooltip.make_int(500, letter).offset_y(-100))


func _on_letter_group_completed(group_id: StringName):
	match group_id:
		&"KICK": _activate_kickbacks()


func _on_letter_group_save_completed():
	pass #TODO
