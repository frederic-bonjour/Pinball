@tool
@icon("res://icons/cube.svg")
class_name Brick
extends RigidBody2D

@export var properties: BrickProperties

const BASE_TEXTURE: Texture2D = preload("res://assets/brick/bricks.png")
const BASE_TEXTURE_HFRAMES: int = 4
const BASE_TEXTURE_VFRAMES: int = 3
const BASE_SHAPE_SIZE: Vector2 = Vector2(60, 60)

@onready var sprite: Sprite2D = $Sprite2D
@onready var cs_square: CollisionShape2D = $CS_Square
@onready var cs_triangle: CollisionPolygon2D = $CS_Triangle
@onready var cs_circle: CollisionShape2D = $CS_Circle

var _remaining_hit_count: int = 1

var size: Vector2:
	get: return Vector2(60, 60) * scale


func _ready() -> void:
	add_to_group(&"bricks")
	if not properties:
		properties = load("res://src/objects/brick/default_brick_properties.tres")
	properties.connect(&"property_changed", _on_property_changed)
	_remaining_hit_count = properties.hits
	if not _update_alt_texture():
		_update_shape()


func _on_property_changed(prop_name: StringName) -> void:
	match prop_name:
		&"scale":
			sprite.scale = properties.scale
		&"shape":
			_update_shape()
		&"alt_texture", &"alt_texture_hframes", &"alt_texture_vframes", &"alt_collision_shape":
			_update_alt_texture()


func _update_alt_texture() -> bool:
	if is_node_ready():
		if properties.alt_texture:
			sprite.texture = properties.alt_texture
			sprite.hframes = properties.alt_texture_hframes if properties.alt_texture_hframes else BASE_TEXTURE_HFRAMES
			sprite.vframes = properties.alt_texture_vframes if properties.alt_texture_vframes else BASE_TEXTURE_VFRAMES
			match properties.alt_collision_shape:
				0: _use_square_shape()
				1: _use_triangle_shape()
				2: _use_circle_shape()
			return true
		else:
			sprite.texture = BASE_TEXTURE
			cs_square.shape.size = BASE_SHAPE_SIZE
			sprite.hframes = BASE_TEXTURE_HFRAMES
			sprite.vframes = BASE_TEXTURE_VFRAMES
	return false


func _update_shape():
	if is_node_ready():
		sprite.frame = properties.shape
		match properties.shape:
			8, 9: _use_triangle_shape()
			10, 11: _use_circle_shape()
			_: _use_square_shape()


func _use_square_shape() -> void:
	cs_square.disabled = false
	cs_triangle.disabled = true
	cs_circle.disabled = true
	cs_square.visible = true
	cs_triangle.visible = false
	cs_circle.visible = false
	cs_square.shape.size = sprite.texture.get_size() / Vector2(sprite.hframes, sprite.vframes)

func _use_circle_shape() -> void:
	cs_square.disabled = true
	cs_triangle.disabled = true
	cs_circle.disabled = false
	cs_square.visible = false
	cs_triangle.visible = false
	cs_circle.visible = true
	cs_circle.shape.radius = sprite.texture.get_size().x / 2.0

func _use_triangle_shape() -> void:
	cs_square.disabled = true
	cs_triangle.disabled = false
	cs_circle.disabled = true
	cs_square.visible = false
	cs_triangle.visible = true
	cs_circle.visible = false
	var s = sprite.texture.get_size()
	cs_triangle.polygon[0] = Vector2(-s.x / 2, -s.y / 2)
	cs_triangle.polygon[1] = Vector2(s.x / 2, -s.y / 2)
	cs_triangle.polygon[2] = Vector2(-s.x / 2, s.y / 2)


func hit() -> int:
	_remaining_hit_count -= 1
	return _remaining_hit_count


func _on_body_entered(body: Node) -> void:
	if body is Ball:
		_remaining_hit_count -= 1
		if _remaining_hit_count == 0:
			SignalHub.brick_hit.emit(self, body, true)
			queue_free()
		else:
			SignalHub.brick_hit.emit(self, body, false)
