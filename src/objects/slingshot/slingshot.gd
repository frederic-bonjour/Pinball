class_name Slingshot
extends Node2D

@export var strength: float = 250.0
@export var open_value: float = 30.0

@onready var pusher = %Pusher
@onready var pusher_collision_shape = $Pusher/CollisionShape2D

var _pusher_rest_position: Vector2
var _offset: float = 0.0
var _dest_offset: float = 0.0

enum { SideLeft = -1, SideRight = 1 }
var _side: int = SideLeft
var _ball_collision_mask: int


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(&"slingshots")
	_side = SideLeft if self.name.containsn("left") else SideRight

	_ball_collision_mask = pusher.collision_mask
	pusher.collision_mask = 0

	_pusher_rest_position = pusher.position


func _process(delta):
	_offset = move_toward(_offset, _dest_offset, delta * strength * randf_range(1.4, 1.8))
	pusher.position = _pusher_rest_position - Vector2(_offset * 2, abs(_offset))
	if (_side == SideRight and _offset >= open_value) or (_side == SideLeft and _offset <= -open_value):
		_dest_offset = 0.0
		pusher.collision_mask = 0


func _on_ball_detection_area_body_entered(body):
	if body is Ball:
		pusher.collision_mask = _ball_collision_mask
		_dest_offset = open_value * _side
		SignalHub.slingshot_bounce.emit(self, body)
