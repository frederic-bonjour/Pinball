class_name PinballBoard
extends Control

@onready var camera: Camera2D = %Camera
@onready var border_line: Line2D = %BorderLine

@export var sfxfb: SfxDb

const BallBounceScene = preload("res://src/fx/ball_bounce_particles.tscn")
const BrickExplosionScene = preload("res://src/fx/brick_explosion.tscn")
const BallScene = preload("res://src/objects/ball/ball.tscn")

var _camera_zoom = 0.5


var _brick_groups: Array[Node]:
	get: return find_children("*", "BrickGroup", true, false)

@warning_ignore("unused_private_class_variable")
var _balls: Array[Node]:
	get: return get_tree().get_nodes_in_group(&"balls")


func _ready():
	if not SfxMusicManager.has_db(&"pinball"):
		SfxMusicManager.add_db(&"pinball", load("res://src/sfxdb_global.tres"))
	SfxMusicManager.add_db(&"board", sfxfb)

	SignalHub.slingshot_hit.connect(_slingshot_hit)
	SignalHub.brick_hit.connect(_brick_hit)
	SignalHub.bumper_hit.connect(_bumper_hit)
	SignalHub.kickback_ejection.connect(_kick_back_ejection)
	SignalHub.brick_group_cleared.connect(_brick_group_cleared)
	SignalHub.letter_group_letter_lit.connect(_on_letter_group_letter_lit)
	SignalHub.letter_group_completed.connect(_on_letter_group_completed_common)
	SignalHub.flipper_hit.connect(_on_flipper_hit)
	SignalHub.wall_hit.connect(_on_wall_hit)
	SessionManager.connect(&"score_changed", _update_score)
	SessionManager.connect(&"score_step_reached", _on_score_steps_reached)
	SessionManager.connect(&"ball_saver_changed", _on_ball_saver_changed)

	_apply_theme()
	_update_score(SessionManager.score)
	_activate_kickbacks()
	_board_ready()


func _apply_theme() -> void:
	var t := get_tree()
	var objects := {
		&"Brick": &"bricks",
		&"Ball": &"balls",
		&"Slingshot": &"slingshots",
		&"Flipper": &"flippers",
		&"Bumper": &"bumpers",
	}
	for theme_name in objects:
		if has_theme_color(&"color", theme_name):
			t.set_group(objects[theme_name], "modulate", get_theme_color(&"color", theme_name))
		var offset_x: int = get_theme_constant(&"shadow_offset_x", theme_name)
		var offset_y: int = get_theme_constant(&"shadow_offset_y", theme_name)
		var offset := Vector2(offset_x, offset_y)
		if offset.length() > 0:
			for b in get_tree().get_nodes_in_group(objects[theme_name]):
				BodySpriteShadow.add_to_body(b, offset)

	for wall in get_tree().get_nodes_in_group(&"walls"):
		var a = wall.modulate.a
		wall.modulate = get_theme_color(&"color", &"SwitchWall" if wall.is_in_group(&"has_rotate_on_flip") else &"Wall")
		wall.modulate.a = a
	border_line.default_color = get_theme_color(&"color", &"Wall")


func new_ball() -> Ball:
	var ball: Ball = BallScene.instantiate()
	ball.modulate = get_theme_color(&"default_color", &"Ball")
	BodySpriteShadow.add_to_body(ball)
	# Give it a position outside the "ball lost area".
	# The ball must be positioned by the Board in its launcher.
	ball.position = Vector2(1920, 1080)
	add_child(ball)
	return ball


func _update_score(_score: int) -> void:
	%ScoreLabel.text = SessionManager.formatted_score


func _on_score_steps_reached(steps: Array[StringName]) -> void:
	if steps.has(&"kickback"):
		_activate_kickbacks()


func _process(delta: float):
	_process_inputs()
	_update_camera(delta)
	_board_process(delta)


func _process_inputs() -> void:
	if Input.is_action_just_pressed(&"teleport_ball"):
		var balls = get_tree().get_nodes_in_group(&"balls")
		if not balls.is_empty():
			balls[0].teleport_to(get_global_mouse_position())
	var tree := get_tree()
	if Input.is_action_just_pressed(&"flipper_left"):
		tree.call_group(&"flipper_left", &"activate")
		tree.call_group(&"rotate_on_flip", &"rotate_left")
		SfxMusicManager.play(&"flipper_up")
	if Input.is_action_just_released(&"flipper_left"):
		tree.call_group(&"flipper_left", &"deactivate")
		SfxMusicManager.play(&"flipper_down", 0.2)

	if Input.is_action_just_pressed(&"flipper_right"):
		tree.call_group(&"flipper_right", &"activate")
		tree.call_group(&"rotate_on_flip", &"rotate_right")
		SfxMusicManager.play(&"flipper_up")
	if Input.is_action_just_released(&"flipper_right"):
		tree.call_group(&"flipper_right", &"deactivate")
		SfxMusicManager.play(&"flipper_down", 0.2)


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
		# Stops the ball
		body.linear_velocity = Vector2.ZERO
		await get_tree().create_timer(1.0).timeout
		SfxMusicManager.play(&"ball_lost")
		SignalHub.ball_lost.emit(body)
		if not SessionManager.ball_lost():
			body.remove_all_components()
		_activate_kickbacks()
		_board_load_ball_in_launcher(body)


func _activate_kickbacks() -> void:
	get_tree().set_group(&"kickbacks", "inactive", false)


func _kick_back_ejection(kickback: KickBack, _ball: PhysicsBody2D, _force: int):
	SfxMusicManager.play_at(&"kickback_ejection", kickback)
	add_score(100, kickback) # FIXME


func _on_kickback_activation_area_body_entered(_body):
	_activate_kickbacks()


func _brick_hit(brick: Brick, _ball, destroyed: bool) -> void:
	SfxMusicManager.play(&"brick_destroyed" if destroyed else &"brick_hit")
	if destroyed:
		var expl = BrickExplosionScene.instantiate()
		expl.position = brick.global_position
		expl.color = brick.modulate
		add_child(expl)

		var points = SessionManager.brick_destroyed(brick)
		add_score(points, brick).offset_y(roundi(brick.size.y / 2.0))


func _bumper_hit(bumper: Bumper, _ball) -> void:
	SfxMusicManager.play_at(&"bumper_negative" if bumper.score < 0 else &"bumper", bumper)
	add_score(bumper.score, bumper).offset_y(-50)


func _slingshot_hit(slingshot: Slingshot, ball: Ball) -> void:
	SfxMusicManager.play_at(&"slingshot", slingshot)
	add_score(50, ball) # FIXME


func _on_letter_group_letter_lit(_group: LetterIndicatorGroup, letter: IndicatorLetter):
	SfxMusicManager.play_at(&"letter_on", letter)
	add_score(500, letter).offset_y(-100) # FIXME


func add_score(value: int, node: Node, large: bool = false) -> VanishingTooltip:
	SessionManager.score += value
	var p = node.global_position
	if node is Control:
		p += node.size / 2
	var t = VanishingTooltip.make_int(value, p)
	if large:
		t.theme_type_variation = &"VanishingTooltipLarge"
	add_child(t)
	return t


var all_brick_groups_cleared: bool:
	get:
		for bg in _brick_groups:
			if not bg.is_empty:
				return false
		return true


func _brick_group_cleared(group_node: BrickGroup) -> void:
	add_score(50000 if all_brick_groups_cleared else 5000, group_node, true) # FIXME
	_check_board_complete()


func _check_board_complete() -> void:
	if _is_board_complete():
		if get_tree().current_scene == self:
			get_tree().quit()
		elif SceneManager.has_next_board():
			SceneManager.next_board()
		else:
			SceneManager.nav_home()


func _on_letter_group_completed_common(group: LetterIndicatorGroup, ball: Ball):
	add_score(2000, group, true)
	match group.letters:
		&"KICK", &"KICKBACK": _activate_kickbacks()
		&"THROUGH": _activate_pass_through_balls()
		&"EXPLOSE": _activate_explosive_balls()
		&"LOAD": _board_load_ball_in_launcher(ball)
		&"SAVE": SessionManager.ball_save_active = true
	_board_on_letter_group_completed(group, ball)
	_check_board_complete()


func _activate_explosive_balls() -> void:
	for b in _balls:
		(b as Ball).add_component(BallComponentExplosive.new())

func _activate_pass_through_balls() -> void:
	for b in _balls:
		(b as Ball).add_component(BallComponentPassThrough.new())


var _ball_wall_ts: int = 0

func _on_wall_hit(_ball: Ball, _wall: Node2D) -> void:
	var now = Time.get_ticks_msec()
	if _ball_wall_ts == 0 or (now - _ball_wall_ts) >= 250:
		SfxMusicManager.play_at(&"ball_wall", _ball)
		_ball_wall_ts = now

func _on_flipper_hit(flipper: Flipper, _ball: Ball) -> void:
	var now = Time.get_ticks_msec()
	if _ball_wall_ts == 0 or (now - _ball_wall_ts) >= 250:
		SfxMusicManager.play_at(&"ball_flipper", flipper)
		_ball_wall_ts = now


func _board_ready() -> void:
	pass


func _board_process(_delta: float) -> void:
	pass


func _on_ball_saver_changed(_active: bool) -> void:
	pass


func _board_load_ball_in_launcher(_ball: Ball):
	pass


func _board_on_letter_group_completed(_group: LetterIndicatorGroup, _ball: Ball):
	pass


func _is_board_complete() -> bool:
	return all_brick_groups_cleared
