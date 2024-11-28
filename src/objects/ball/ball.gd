@icon("res://icons/baseball-ball.svg")
class_name Ball
extends RigidBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

@export var properties: BallProperties


func _ready() -> void:
	_update_properties()


func _update_properties() -> void:
	if is_node_ready():
		self.mass = properties.mass
		self.collision_shape.shape.radius = properties.radius
		self.sprite.texture = properties.texture


var reset_state = false
var move_vector: Vector2

func _integrate_forces(state):
	if reset_state:
		state.transform = Transform2D(0.0, move_vector)
		linear_velocity = Vector2.ZERO
		reset_state = false


func teleport_to(target_pos: Vector2):
	move_vector = target_pos;
	reset_state = true;


func _on_body_entered(body: Node) -> void:
	if body as ModularWall:
		SignalHub.ball_touched_modular_wall.emit(self, body)
	elif body.name.containsn(&"wall"):
		SignalHub.ball_touched_wall.emit(self, body)
	elif body is Flipper:
		SignalHub.ball_touched_flipper.emit(self, body)
