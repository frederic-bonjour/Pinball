class_name ComponentRotateOnFlip
extends Node

signal finished(index: int)
signal reset_done

@export var angles_l2r: Array[int] = [0, -90]
@export var initial_angle_index: int = 0
@export var speed: int = 250
@export var cycle: bool = false

var _angle: float = 0.0
var _index: int = 0:
	set(v):
		if cycle:
			_index = wrap(v, 0, angles_l2r.size())
		else:
			_index = clamp(v, 0, angles_l2r.size() - 1)
		_angle = angles_l2r[_index]

var _target: Node2D

enum { Ready, Resetting }
var _state = Ready


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(&"rotate_on_flip")
	_index = initial_angle_index
	_target = get_parent()
	_target.add_to_group(&"has_rotate_on_flip")


func rotate_left() -> void:
	if _state == Ready:
		_index -= 1


func rotate_right() -> void:
	if _state == Ready:
		_index += 1


func reset() -> Signal:
	_index = initial_angle_index
	_state = Resetting
	return reset_done


func _process(delta: float) -> void:
	_target.rotation_degrees = move_toward(_target.rotation_degrees, _angle, delta * speed)
	if is_equal_approx(_target.rotation_degrees, _angle):
		if _index == initial_angle_index and _state == Resetting:
			_state = Ready
			reset_done.emit()
		else:
			finished.emit(_index)
