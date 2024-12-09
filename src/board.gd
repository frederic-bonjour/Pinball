class_name PinballBoard
extends Control

@onready var camera: Camera2D = %Camera
@onready var launcher: Node2D = %Launcher
@onready var launcher_rotate_on_flip: ComponentRotateOnFlip = %Launcher/RotateOnFlip
@onready var effects: Control = %Effects
@onready var border_line: Line2D = %BorderLine


const BallBounceScene = preload("res://src/fx/ball_bounce_particles.tscn")
const BrickExplosionScene = preload("res://src/fx/brick_explosion.tscn")

var _ball_initial_position: Vector2
var _camera_zoom = 0.5

var _brick_groups: Array[Node]:
	get: return find_children("*", "BrickGroup", true, false)


func _ready():
	_ball_initial_position = launcher.global_position - Vector2(0, 60)

	var t := get_tree()
	t.set_group(&"slingshots", "modulate", get_theme_color(&"color", &"Slingshot"))
	t.set_group(&"bumpers", "modulate", get_theme_color(&"color", &"Bumper"))
	t.set_group(&"flippers", "modulate", get_theme_color(&"color", &"Flipper"))
	t.set_group(&"balls", "modulate", get_theme_color(&"default_color", &"Ball"))
	t.set_group(&"walls", "modulate", get_theme_color(&"color", &"Wall"))
	border_line.default_color = get_theme_color(&"color", &"Wall")
	launcher.modulate = get_theme_color(&"color", &"Launcher")

	SignalHub.slingshot_hit.connect(_slingshot_hit)
	SignalHub.brick_hit.connect(_brick_hit)
	SignalHub.bumper_hit.connect(_bumper_hit)
	SignalHub.kickback_ejection.connect(_kick_back_ejection)
	SignalHub.brick_group_cleared.connect(_brick_group_cleared)

	_update_score(SessionManager.score)
	SessionManager.connect(&"score_changed", _update_score)
	SessionManager.connect(&"score_step_reached", _on_score_steps_reached)

	SignalHub.connect(&"letter_group_letter_lit", _on_letter_group_letter_lit)
	SignalHub.connect(&"letter_group_completed", _on_letter_group_completed_common)

	_activate_kickbacks()
	_board_ready()


func _board_ready() -> void:
	pass


func _update_score(_score: int) -> void:
	%ScoreLabel.text = SessionManager.formatted_score


func _on_score_steps_reached(steps: Array[StringName]) -> void:
	if steps.has(&"kickback"):
		_activate_kickbacks()


func _process(delta: float):
	_process_inputs()
	_update_camera(delta)
	_update_balls_trails()


func _update_balls_trails() -> void:
	pass


func _process_inputs() -> void:
	if Input.is_action_just_pressed(&"teleport_ball"):
		var balls = get_tree().get_nodes_in_group(&"balls")
		if not balls.is_empty():
			balls[0].teleport_to(get_global_mouse_position())
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
			_camera_zoom = 0.65
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

"""
func _add_ball_touch_particles(_body: Node2D, _ball: Ball) -> void:
	var particles = BallBounceScene.instantiate()
	particles.top_level = true
	particles.position = _ball.global_position
	effects.add_child(particles)
"""

func _kick_back_ejection(kickback: KickBack, _ball: PhysicsBody2D, _force: int):
	add_score(100, kickback) # FIXME


func _on_kickback_activation_area_body_entered(_body):
	_activate_kickbacks()


func _brick_hit(brick: Brick, _ball, destroyed: bool) -> void:
	if destroyed:
		var expl = BrickExplosionScene.instantiate()
		expl.position = brick.global_position
		expl.color = brick.modulate
		add_child(expl)

		var points = SessionManager.brick_destroyed(brick)
		add_score(points, brick).offset_y(roundi(brick.size.y / 2.0))


func _bumper_hit(bumper: Bumper, _ball) -> void:
	add_score(bumper.score, bumper).offset_y(-50)


func _slingshot_hit(_slingshot: Slingshot, ball: Ball) -> void:
	add_score(50, ball) # FIXME


func _on_letter_group_letter_lit(_group: LetterIndicatorGroup, letter: IndicatorLetter):
	SfxManager.play_audio(&"letter_on", letter)
	add_score(500, letter).offset_y(-100) # FIXME


func add_score(value: int, node: Node, large: bool = false) -> VanishingTooltip:
	SessionManager.score += value
	var p = node.global_position
	if node is Control:
		p += node.size / 2
	var t = VanishingTooltip.make_int(value, p)
	if large:
		t.theme_type_variation = &"VanishingTooltipLarge"
	effects.add_child(t)
	return t


var all_brick_groups_cleared: bool:
	get:
		for bg in _brick_groups:
			if not bg.is_empty:
				return false
		return true


func _brick_group_cleared(group_node: BrickGroup) -> void:
	add_score(50000 if all_brick_groups_cleared else 5000, group_node, true) # FIXME


func _on_letter_group_completed_common(group: LetterIndicatorGroup):
	add_score(2000, group, true)
	if group.name.ends_with(&"_KICK"):
		_activate_kickbacks()
	elif group.name.ends_with(&"_SAVE"):
		pass # TODO
	else:
		_on_letter_group_completed(group)


func _on_letter_group_completed(_group: LetterIndicatorGroup):
	pass
