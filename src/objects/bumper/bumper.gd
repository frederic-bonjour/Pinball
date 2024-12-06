@tool
class_name Bumper
extends Node2D

@export var max_strength: int = 500
@export var score: int = 100

@onready var collision_shape = %CollisionShape
@onready var area_collision_shape = $BallDetectionArea/AreaCollisionShape
@onready var sprite: Sprite2D = $Sprite2D

var _dest_scale: Vector2
var _strength: float = 150.0


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(&"bumpers")
	set_physics_process(false)
	sprite.scale = Vector2.ONE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	sprite.scale = sprite.scale.move_toward(_dest_scale, delta * _strength)
	if sprite.scale == Vector2.ONE:
		set_physics_process(false)


func _on_body_entered(body):
	if body is Ball:
		_dest_scale = Vector2(1.2, 1.2)
		_strength = clamp(remap(body.linear_velocity.length_squared(), 0, 9_000_000, 200, 10), roundi(max_strength / 5.0), max_strength)
		body.linear_velocity = body.linear_velocity.normalized() * 1500
		SignalHub.bumper_hit.emit(self, body)
		set_physics_process(true)


func _on_body_exited(body):
	if body is Ball:
		_dest_scale = Vector2.ONE
