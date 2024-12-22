@tool
class_name KickBack
extends Node2D

signal loading(value: float)

@export var indicator: Node2D

@export_group("Ejection")
@export var strength: float = 50000.0
@export var auto_eject: bool = true

## The time, in milliseconds, after which the ball is automatically ejected.
@export var auto_eject_time: int = 500

@export var load_duration: int = 500

@export_group("Activation")
@export var always_active: bool = false
@export var inactive: bool = false:
	set(v):
		inactive = false if always_active else v
		if not inactive and auto_inactive_delay > 0:
			_auto_inactive_ts = Time.get_ticks_msec() + auto_inactive_delay
		if is_node_ready():
			$Area2D/CollisionShape2D.set_deferred(&"disabled", inactive)
			$Blocker/CollisionShape2D.set_deferred(&"disabled", inactive or disable_blocker_body)
			if indicator:
				indicator.modulate = Color(1, 1, 1, 0.25) if inactive else Color(2, 3, 2)
			top_line.visible = not inactive

@export var auto_inactive_delay: int = 0

@export var disable_blocker_body: bool = false:
	set(v):
		disable_blocker_body = v
		if is_node_ready():
			$Blocker.visible = not disable_blocker_body
			$Blocker/CollisionShape2D.set_deferred(&"disabled", inactive or disable_blocker_body)

var is_loaded: bool:
	get: return _loaded_body != null


@onready var top_line = %TopLine

var _auto_inactive_ts: int = 0

#const STATE_NAMES: Array[StringName] = [&"Idle", &"Ready", &"Loading", &"Waiting", &"Ejection", &"Ejecting", &"Ejected"]
enum { Idle, Ready, Loading, Waiting, Ejection, Ejecting, Ejected }
var _state = Idle:
	set(v):
		_state = v
		_state_ts = Time.get_ticks_msec()

var _state_ts: int = 0

var _loaded_body: RigidBody2D
var _player_strength: float
var _body_present: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(&"kickbacks")
	_state = Idle
	inactive = inactive
	disable_blocker_body = disable_blocker_body


# Called every frame. '_delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	var now = Time.get_ticks_msec()
	var elapsed = now - _state_ts

	match _state:
		Idle:
			if _auto_inactive_ts > 0 and now >= _auto_inactive_ts:
				inactive = true
			if _body_present:
				_state = Ready

		Ready:
			if auto_eject:
				if _is_body_stopped():
					_state = Loading
			else:
				_state = Waiting

		Waiting:
			if Input.is_action_pressed(&"launch"):
				_state = Loading

		Loading:
			var load_time: int = clamp(now - _state_ts, 0, load_duration)
			var load_value: float = float(load_time) / load_duration
			SignalHub.kickback_loading.emit(self, load_value)
			loading.emit(load_value)
			if auto_eject:
				if load_time == load_duration:
					_state = Ejection
			elif Input.is_action_just_released(&"launch"):
				_player_strength = strength * load_value
				_state = Ejection

		Ejection:
			var s = strength * randf_range(0.95, 1.05) if auto_eject else _player_strength
			if _loaded_body:
				_loaded_body.linear_damp = _prev_body_damp
				_loaded_body.apply_central_impulse(Vector2.from_angle(global_rotation + PI / 2.0) * -s)
				SignalHub.kickback_ejection.emit(self, _loaded_body, s)
				SignalHub.kickback_loading.emit(self, 0)
				loading.emit(0)
				_state = Ejecting
			else:
				_state = Idle

		Ejecting:
			if elapsed > 250:
				if not _body_present:
					_state = Ejected
				elif _is_body_stopped():
					_state = Ready

		Ejected:
			_state = Idle
			inactive = true


var _prev_body_damp: float

func _on_body_entered_detection_area(body: Node2D):
	_body_present = true
	_loaded_body = body
	_prev_body_damp = _loaded_body.linear_damp
	_loaded_body.linear_damp = 8
	SignalHub.kickback_ball_entered.emit(self, body)


func _on_body_exited_detection_area(body):
	body.linear_damp = _prev_body_damp
	_body_present = false
	_loaded_body = null


func _is_body_stopped() -> bool:
	return false if not _loaded_body else _loaded_body.linear_velocity.length_squared() < 10


func load_ball(ball: Ball) -> void:
	ball.teleport_to($Area2D.global_position)
