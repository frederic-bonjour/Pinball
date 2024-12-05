@icon("res://icons/baseball-ball.svg")
class_name Ball
extends RigidBody2D


@export var properties: BallProperties

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D


var _reset_state = false
var _teleport_vector: Vector2


func _ready() -> void:
	add_to_group(&"balls")
	_update_properties()


func _update_properties() -> void:
	if is_node_ready():
		self.mass = properties.mass
		self.collision_shape.shape.radius = properties.radius
		self.sprite.texture = properties.texture


func _integrate_forces(state):
	if _reset_state:
		state.transform = Transform2D(0.0, _teleport_vector)
		linear_velocity = Vector2.ZERO
		_reset_state = false


func teleport_to(target_pos: Vector2):
	_teleport_vector = target_pos;
	_reset_state = true


func _on_body_entered(body: Node) -> void:
	if body as ModularWall or body.name.containsn(&"wall"):
		SignalHub.wall_hit.emit(body, self)
	elif body is Flipper:
		SignalHub.flipper_hit.emit(body, self)
