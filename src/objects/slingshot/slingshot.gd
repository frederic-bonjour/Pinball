extends Node2D

@export var strength: float = 250.0
@export var open_value: float = 30.0

@onready var pusher1 = $Pusher1
@onready var pusher2 = $Pusher2
@onready var pusher_line = $PusherLine

var _pusher1_rest_rotation: float
var _pusher2_rest_rotation: float
var _offset: float = 0.0
var _dest_offset: float = 0.0

enum { SideLeft = -1, SideRight = 1 }
var _side: int = SideLeft

var _pusher_line_center


# Called when the node enters the scene tree for the first time.
func _ready():
	_pusher1_rest_rotation = pusher1.rotation_degrees
	_pusher2_rest_rotation = pusher2.rotation_degrees
	_pusher_line_center = pusher_line.get_point_position(1)
	_side = SideLeft if self.name.containsn("left") else SideRight


func _process(delta):
	_offset = move_toward(_offset, _dest_offset, delta * strength)
	pusher1.rotation_degrees = _pusher1_rest_rotation + _offset
	pusher2.rotation_degrees = _pusher2_rest_rotation - _offset
	pusher_line.set_point_position(1, _pusher_line_center - Vector2(_offset * 2, abs(_offset)))
	if (_side == SideRight and _offset >= open_value) or (_side == SideLeft and _offset <= -open_value):
		_dest_offset = 0.0


func _on_ball_detection_area_body_entered(body):
	if body is Ball:
		_dest_offset = open_value * _side
