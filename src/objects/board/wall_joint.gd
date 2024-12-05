@tool
class_name WallJoint
extends Node2D

@export var properties: WallJointProperties:
	set(v):
		properties = v
		_update_radius()
		queue_redraw()


@onready var collision_shape = $CollisionShape2D

var _theme: BoardTheme


func _ready():
	_theme = Utils.get_board(self).board_theme
	properties.connect(&"property_changed", _on_property_changed)
	_update_radius()


func _on_property_changed(prop_name: StringName) -> void:
	queue_redraw()
	match prop_name:
		&"radius": _update_radius()


func _update_radius() -> void:
	if collision_shape:
		(collision_shape.shape as CircleShape2D).radius = properties.radius + 2


func _draw() -> void:
	if properties.hole_radius > 0.0:
		var thickness: float = properties.radius - properties.hole_radius
		draw_circle(Vector2.ZERO, properties.radius - thickness / 2, _theme.walls_color, false, thickness, true)
	else:
		draw_circle(Vector2.ZERO, properties.radius, _theme.walls_color, true, -1, true)
