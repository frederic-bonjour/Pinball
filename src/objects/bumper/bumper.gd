@tool
class_name Bumper
extends Node2D

@export var radius: float = 50:
	set(v):
		radius = v
		_update_properties()

@onready var ellipse = %Ellipse
@onready var collision_shape = %CollisionShape

var _extend: float = 0.0
var _dest_extend: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	_update_properties()


func _update_properties() -> void:
	if is_node_ready():
		ellipse.size.x = radius * 2
		ellipse.size.y = radius * 2
		(collision_shape.shape as CircleShape2D).radius = radius + 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_extend = move_toward(_extend, _dest_extend, delta * 150)
	(collision_shape.shape as CircleShape2D).radius = radius + 5 + _extend
	ellipse.size.x = radius * 2 + _extend
	ellipse.size.y = radius * 2 + _extend


func _on_body_entered(body):
	if body is Ball:
		_dest_extend = 75 if body.linear_velocity.y < 0 else 25
		body.linear_velocity *= 1.2


func _on_body_exited(body):
	if body is Ball:
		_dest_extend = 0
