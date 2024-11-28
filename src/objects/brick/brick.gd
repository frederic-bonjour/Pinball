@tool
@icon("res://icons/cube.svg")
class_name Brick
extends RigidBody2D

@export var properties: BrickProperties = BrickProperties.new()

@onready var sprite: Sprite2D = $Sprite2D
@onready var cs_square: CollisionShape2D = $CS_Square
@onready var cs_triangle: CollisionPolygon2D = $CS_Triangle
@onready var cs_circle: CollisionShape2D = $CS_Circle

var _remaining_hit_count: int = 1


func _ready() -> void:
	properties.connect(&"property_changed", _on_property_changed)
	_remaining_hit_count = properties.hits
	_update_shape()


func _on_property_changed(prop_name: StringName) -> void:
	match prop_name:
		&"shape": _update_shape()


func _update_shape():
	if is_node_ready():
		sprite.frame = properties.shape
		cs_square.disabled = properties.shape > 7
		cs_triangle.disabled = properties.shape < 8 or properties.shape > 9
		cs_circle.disabled = properties.shape < 10
		cs_square.visible = not cs_square.disabled
		cs_triangle.visible = not cs_triangle.disabled
		cs_circle.visible = not cs_circle.disabled


func _on_body_entered(body: Node) -> void:
	if body is Ball:
		_remaining_hit_count -= 1
		if _remaining_hit_count == 0:
			SignalHub.brick_destroyed.emit(self, body)
			queue_free()
		else:
			SignalHub.brick_touched.emit(self, body)
