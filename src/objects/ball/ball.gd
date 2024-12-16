class_name Ball
extends RigidBody2D

@export var properties: BallProperties

#region The signals here are meant to be used "locally" by Ball's Components.
signal touched_brick(brick: Brick, destroyed: bool)
signal touched_wall(wall)
signal touched_flipper(flipper: Flipper)
signal touched_bumper(bumper: Bumper)
#endregion

@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var sprite: Sprite2D = $Sprite
@onready var particles: CPUParticles2D = $"Trail Particles"

var _reset_state = false
var _teleport_vector: Vector2


func _ready() -> void:
	add_to_group(&"balls")
	add_to_group(&"bodies_with_shadow")
	_update_properties()


#region Components
func add_component(component: Node) -> bool:
	component.name = "Component_%s" % component.name
	if not get_node_or_null(str(component.name)):
		add_child(component)
		return true
	return false


func remove_component(component_name: StringName) -> bool:
	var n = get_node_or_null("Component_%s" % component_name)
	if n:
		remove_child(n)
		n.queue_free()
		return true
	return false


func remove_all_components() -> void:
	for c in find_children("Component_*", "", false, false):
		remove_child(c)
		c.queue_free()
#endregion


func _update_properties() -> void:
	if is_node_ready():
		self.mass = properties.mass
		self.collision_shape.shape.radius = properties.radius
		self.sprite.texture = properties.texture


func _physics_process(_delta: float) -> void:
	particles.rotation = -rotation
	particles.emitting = linear_velocity.length_squared() > 25_000


func _integrate_forces(state):
	if _reset_state:
		state.transform = Transform2D(0.0, _teleport_vector)
		linear_velocity = Vector2.ZERO
		_reset_state = false
	else:
		if linear_velocity.length_squared() > 20_000_000: # TODO Needed?
			linear_velocity = linear_velocity.normalized() * 4400


func teleport_to(target_pos: Vector2):
	_teleport_vector = target_pos
	_reset_state = true


func _on_body_entered(body: Node) -> void:
	if body is Brick:
		var destroyed = body.hit() == 0
		touched_brick.emit(body, destroyed)
		SignalHub.brick_hit.emit(body, self, destroyed)
		if destroyed:
			body.queue_free()
	elif body as ModularWall or body.name.containsn(&"wall"):
		touched_wall.emit(body)
		SignalHub.wall_hit.emit(body, self)
	elif body is Flipper:
		touched_flipper.emit(body)
		SignalHub.flipper_hit.emit(body, self)
	elif body is Bumper:
		touched_bumper.emit(body)
		SignalHub.bumper_hit.emit(body, self)
