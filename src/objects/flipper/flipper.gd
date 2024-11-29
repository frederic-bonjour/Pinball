@tool
class_name Flipper
extends RigidBody2D


@export_enum("left:0", "right:1") var side: int = 0:
	set(v):
		side = v
		_update_side()

@export var angle_degrees: float = 45
@export_range(10, 25) var strength: float = 15

@onready var sprite = $Sprite2D
@onready var collision_polygon = $CollisionPolygon2D

var _initial_rotation: float
var _active_rotation: float
var _desired_rotation: float
var _speed: float


# Called when the node enters the scene tree for the first time.
func _ready():
	_initial_rotation = rotation
	_active_rotation = _initial_rotation + deg_to_rad(angle_degrees)
	_desired_rotation = _initial_rotation
	_update_side()
	add_to_group(&"flippers")
	add_to_group(&"flipper_left" if side == 0 else &"flipper_right")


func _update_side() -> void:
	if sprite:
		sprite.flip_h = side == 1
		sprite.position.x = 101 if side == 0 else -101
	if collision_polygon:
		collision_polygon.scale.x = -1 if side == 1 else 1


func activate() -> void:
	_desired_rotation = _active_rotation
	_speed = strength
	set_process(true)


func deactivate() -> void:
	_desired_rotation = _initial_rotation
	_speed = strength * 0.25
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	rotation = move_toward(rotation, _desired_rotation, delta * _speed)
	if rotation == _desired_rotation:
		set_process(false)
