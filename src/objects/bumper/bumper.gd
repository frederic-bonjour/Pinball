@tool
class_name Bumper
extends Node2D

@export var radius: float = 65:
	set(v):
		radius = v
		_update_properties()

@onready var ellipse = %Ellipse
@onready var collision_shape = %CollisionShape
@onready var area_collision_shape = $BallDetectionArea/AreaCollisionShape

var _extend: float = 0.0
var _dest_extend: float = 0.0
var _strength: float = 150.0


# Called when the node enters the scene tree for the first time.
func _ready():
	_update_properties()


func _update_properties() -> void:
	if is_node_ready():
		ellipse.size.x = radius * 2
		ellipse.size.y = radius * 2
		(collision_shape.shape as CircleShape2D).radius = radius
		(area_collision_shape.shape as CircleShape2D).radius = radius + 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_extend = move_toward(_extend, _dest_extend, delta * _strength)
	(collision_shape.shape as CircleShape2D).radius = radius + _extend
	ellipse.size.x = radius * 2 + _extend
	ellipse.size.y = radius * 2 + _extend


func _on_body_entered(body):
	if body is Ball:
		_dest_extend = 25
		_strength = clamp(remap(body.linear_velocity.length_squared(), 0, 9_000_000, 200, 10), 10, 200)
		body.linear_velocity = body.linear_velocity.normalized() * 1200


func _on_body_exited(body):
	if body is Ball:
		_dest_extend = 0
