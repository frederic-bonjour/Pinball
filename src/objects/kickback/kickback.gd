@tool
class_name KickBack
extends Node2D

signal loaded(body: PhysicsBody2D)
signal ejected(body: PhysicsBody2D, kickback: KickBack, force: int)


@export_group("Ejection")
@export var amplitude: float = 100.0:
	set(v):
		amplitude = v
		if is_node_ready():
			bottom_line.position.y = amplitude - 50

@export var strength: float = 50000.0
@export var auto_eject: bool = true
## The time, in milliseconds, after which the ball if automatically ejected.
@export var auto_eject_time: int = 500
@export var load_duration: int = 500

@export_group("Activation")
@export var always_active: bool = false
@export var disable_movement: bool = false
@export var inactive: bool = false:
	set(v):
		inactive = false if always_active else v
		if not inactive and auto_inactive_delay > 0:
			_auto_inactive_ts = Time.get_ticks_msec() + auto_inactive_delay
		if is_node_ready():
			bottom_line.visible = not inactive and not disable_movement
			top_line.visible = not inactive
			for cs in find_children("*", "CollisionShape2D"):
				cs.set_deferred(&"disabled", inactive)
			if _indicator:
				_indicator.visible = not inactive

@export var auto_inactive_delay: int = 0

@onready var holder = $Holder
@onready var bottom_line = $BottomLine
@onready var top_line = $Holder/TopLine

var _indicator: Node
var _auto_inactive_ts: int = 0

enum { Idle, Ready, Loading, Waiting, Eject, Ejecting, Cooldown }
var _state = Idle:
	set(v):
		_state = v
		_state_ts = Time.get_ticks_msec()

var _state_ts: int = 0

var _holder_idle_position: float
var _holder_max_position: float

var _loaded_body: RigidBody2D
var _player_strength: float
var _body_present: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(&"kickbacks")
	_holder_idle_position = holder.position.y
	_holder_max_position = _holder_idle_position + amplitude
	_state = Idle
	bottom_line.position.y = amplitude - 50
	_indicator = get_node_or_null("Indicator")
	inactive = inactive


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var now = Time.get_ticks_msec()

	match _state:
		Idle:
			if _auto_inactive_ts > 0 and now >= _auto_inactive_ts:
				inactive = true

		Ready:
			if auto_eject:
				if now - _state_ts >= auto_eject_time:
					_state = Loading
			else:
				_state = Waiting

		Waiting:
			if Input.is_action_pressed(&"launch"):
				_state = Loading

		Loading:
			var load_time: int = clamp(now - _state_ts, 0, load_duration)
			var load_value: float = float(load_time) / load_duration
			if not disable_movement:
				holder.position.y = lerpf(_holder_idle_position, _holder_max_position, load_value)
			if auto_eject:
				if load_time == load_duration:
					_state = Ejecting
					ejected.emit(_loaded_body, self, strength)
			elif Input.is_action_just_released(&"launch"):
				_player_strength = strength * load_value
				_state = Ejecting
				ejected.emit(_loaded_body, self, _player_strength)

		Ejecting:
			if not disable_movement:
				holder.position.y = move_toward(holder.position.y, _holder_idle_position, delta * 750)
			var s = strength if auto_eject else _player_strength
			_loaded_body.apply_central_impulse(Vector2.from_angle(rotation + PI / 2.0) * -s)
			if disable_movement:
				_state = Idle
			elif is_equal_approx(holder.position.y, _holder_idle_position) and not _body_present:
				_state = Cooldown

		Cooldown:
			if not disable_movement:
				holder.position.y = _holder_idle_position
			_state = Ready if _body_present else Idle


func _on_body_entered_detection_area(body: Node2D):
	_body_present = true
	_loaded_body = body
	_state = Ready
	loaded.emit(body)


func _on_body_exited_detection_area(_body):
	_body_present = false
	match _state:
		Ready, Waiting, Loading: _state = Idle
