extends Node

var _angle: float = 0
@export var left_angle: float = 0
@export var right_angle: float = -90


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(&"rotate_on_flip")
	rotate_left()


func rotate_left() -> void:
	_angle = left_angle


func rotate_right() -> void:
	_angle = right_angle


func _process(delta: float) -> void:
	get_parent().rotation_degrees = move_toward(get_parent().rotation_degrees, _angle, delta * 250)
