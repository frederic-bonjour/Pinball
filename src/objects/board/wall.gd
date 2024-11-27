@tool
class_name ModularWall
extends Node2D

@export var properties: WallProperties:
	set(v):
		properties = v
		_update_properties()

@onready var static_body: StaticBody2D = $StaticBody2D
@onready var cs_capsule: CollisionShape2D = $StaticBody2D/CSCapsule
@onready var cs_rectangle: CollisionShape2D = $StaticBody2D/CSRectangle

var radius: float:
	get: return properties.thickness / 2.0

var half_length: float:
	get: return properties.length / 2.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	properties.connect(&"property_changed", _update_ui)
	_update_collision_shape()
	_update_body()


func _update_properties() -> void:
	_update_collision_shape()
	queue_redraw()


func _update_ui(prop_name: StringName) -> void:
	match prop_name:
		&"color", \
		&"rounded":
			queue_redraw()

		&"length", \
		&"thickness", \
		&"collision_rounded", \
		&"adjust_collision_margin":
			_update_collision_shape()
			queue_redraw()

		&"physics_material":
			_update_body()


func _update_collision_shape() -> void:
	if is_node_ready():
		if properties.collision_rounded:
			cs_capsule.disabled = false
			cs_rectangle.disabled = true
			var shape: CapsuleShape2D = cs_capsule.shape
			shape.height = properties.length + properties.adjust_collision_margin.y
			shape.radius = radius + properties.adjust_collision_margin.x
		else:
			cs_capsule.disabled = true
			cs_rectangle.disabled = false
			var shape: RectangleShape2D = cs_rectangle.shape
			shape.size.x = properties.thickness + properties.adjust_collision_margin.x
			shape.size.y = properties.length + properties.adjust_collision_margin.y
		cs_capsule.visible = not cs_capsule.disabled
		cs_rectangle.visible = not cs_rectangle.disabled


func _update_body() ->void:
	if is_node_ready():
		static_body.physics_material_override = properties.physics_material


func _draw() -> void:
	if properties.rounded:
		var y1 = -half_length + radius
		var y2 = half_length - radius
		draw_circle(Vector2(0, y1), radius, properties.color, true, -1.0, true)
		draw_circle(Vector2(0, y2), radius, properties.color, true, -1.0, true)
		draw_rect(Rect2(-radius, y1, properties.thickness, properties.length - properties.thickness), properties.color, true, -1.0, true)
	else:
		draw_rect(Rect2(-radius, -half_length, properties.thickness, properties.length), properties.color, true, -1.0, true)
