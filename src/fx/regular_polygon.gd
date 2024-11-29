@tool
extends Node2D

@onready var collision_polygon = $StaticBody2D/CollisionPolygon2D

@export_enum(
	"triangle (3):3",
	"square (4):4",
	"pentagon (5):5",
	"hexagon (6):6",
	"heptagon (7):7",
	"octagon (8):8"
) var edges: int = 6:
	set(v):
		edges = v
		_rebuild_points()
		queue_redraw()

@export var filled: bool = false:
	set(v):
		filled = v
		queue_redraw()

@export var diameter: float = 100.0:
	set(v):
		diameter = v
		_rebuild_points()
		queue_redraw()

@export var fill_color: Color = Color(0, 0, 0, 0.2):
	set(v):
		fill_color = v
		queue_redraw()

@export var stroke_color: Color = Color(0, 0, 0, 0.2):
	set(v):
		stroke_color = v
		queue_redraw()

@export var stroke_width: float = 10.0:
	set(v):
		stroke_width = v
		queue_redraw()

@export var revolution_duration: float = 10.0

@export var is_collider: bool = false:
	set(v):
		is_collider = v
		_update_collider()

@export_enum("CW", "CCW") var rotation_direction: int = 0


var _polygon_points: Array
var _stroke_points: Array


func _rebuild_points() -> void:
	_polygon_points.clear()
	_stroke_points.clear()
	var step := TAU / float(edges)
	for v in edges:
		var p = Vector2.from_angle(step * v) * diameter
		_polygon_points.append(p)
		_stroke_points.append(p)
	_stroke_points.append(_stroke_points[0])


# Called when the node enters the scene tree for the first time.
func _ready():
	_rebuild_points()
	_update_collider()
	if not Engine.is_editor_hint():
		if revolution_duration > 0.0:
			var t = create_tween()
			if rotation_direction == 0:
				t.tween_property(self, "rotation_degrees", 360.0, revolution_duration).from(0.0)
			else:
				t.tween_property(self, "rotation_degrees", -360.0, revolution_duration).from(0.0)
			t.set_loops()


func _update_collider() -> void:
	if collision_polygon:
		if is_collider:
			collision_polygon.polygon = _polygon_points
			collision_polygon.disabled = false
		else:
			collision_polygon.disabled = true


func _draw():
	if filled:
		draw_colored_polygon(_polygon_points, fill_color)
	if stroke_width > 0.0:
		draw_polyline(_stroke_points, stroke_color, stroke_width, true)
