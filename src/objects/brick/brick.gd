@tool
class_name Brick
extends RigidBody2D

@warning_ignore("unused_signal")
signal touched(brick: Brick)

@export var properties: BrickProperties:
	set(v):
		if v != properties:
			if properties:
				properties.disconnect(&"property_changed", _on_property_changed)
			properties = v
			if properties:
				properties.connect(&"property_changed", _on_property_changed)
			_update_shape()

@export var properties_alt: BrickPropertiesAlt:
	set(v):
		if v != properties_alt:
			if properties_alt:
				properties_alt.disconnect(&"property_changed", _on_alt_property_changed)
			properties_alt = v
			if properties_alt:
				properties_alt.connect(&"property_changed", _on_alt_property_changed)

		if is_node_ready():
			if properties_alt:
				_use_alt_texture()
			else:
				_use_default_texture()


const BASE_TEXTURE: Texture2D = preload("res://assets/brick/bricks.png")
const BASE_TEXTURE_HFRAMES: int = 4
const BASE_TEXTURE_VFRAMES: int = 3
const BASE_SHAPE_SIZE: Vector2 = Vector2(60, 60)

@onready var sprite: Sprite2D = $Sprite
@onready var cs_square: CollisionShape2D = $CS_Square
@onready var cs_triangle: CollisionPolygon2D = $CS_Triangle
@onready var cs_circle: CollisionShape2D = $CS_Circle

var _remaining_hit_count: int = 1

var size: Vector2:
	get: return Vector2(60, 60) * scale

var sprite_size: Vector2:
	get: return (sprite.texture.get_size() / Vector2(sprite.hframes, sprite.vframes)) * properties.scale


func _ready() -> void:
	add_to_group(&"bricks")
	add_to_group(&"bodies_with_shadow")
	if not properties:
		properties = load("res://src/objects/brick/default_brick_properties.tres")
	else:
		properties = properties
	_remaining_hit_count = properties.hits
	properties_alt = properties_alt


func _on_alt_property_changed(prop_name: StringName) -> void:
	match prop_name:
		&"texture", \
		&"texture_hframes", \
		&"texture_vframes", \
		&"frame", \
		&"collision_shape":
			_use_alt_texture()

func _on_property_changed(prop_name: StringName) -> void:
	match prop_name:
		&"scale":
			sprite.scale = properties.scale
		&"shape":
			_update_shape()


func _use_alt_texture() -> void:
	sprite.texture = properties_alt.texture
	sprite.hframes = properties_alt.hframes
	sprite.vframes = properties_alt.vframes
	sprite.frame = properties_alt.frame
	match properties_alt.collision_shape:
		0: _use_square_shape()
		1: _use_triangle_shape()
		2: _use_circle_shape()
	

func _use_default_texture() -> void:
	sprite.texture = BASE_TEXTURE
	cs_square.shape.size = BASE_SHAPE_SIZE
	sprite.hframes = BASE_TEXTURE_HFRAMES
	sprite.vframes = BASE_TEXTURE_VFRAMES
	sprite.frame = properties.shape
	_update_shape()


func _update_shape():
	if is_node_ready():
		sprite.scale = properties.scale
		sprite.frame = properties.shape
		match properties.shape:
			8, 9: _use_triangle_shape()
			10, 11: _use_circle_shape()
			_: _use_square_shape()


func update_scale(offset: Vector2) -> void:
	properties.scale += offset
	_update_shape.call_deferred()


func _use_square_shape() -> void:
	cs_square.disabled = false
	cs_triangle.disabled = true
	cs_circle.disabled = true
	cs_square.visible = true
	cs_triangle.visible = false
	cs_circle.visible = false
	cs_square.shape.size = sprite_size

func _use_circle_shape() -> void:
	cs_square.disabled = true
	cs_triangle.disabled = true
	cs_circle.disabled = false
	cs_square.visible = false
	cs_triangle.visible = false
	cs_circle.visible = true
	cs_circle.shape.radius = sprite_size.x / 2.0

func _use_triangle_shape() -> void:
	cs_square.disabled = true
	cs_triangle.disabled = false
	cs_circle.disabled = true
	cs_square.visible = false
	cs_triangle.visible = true
	cs_circle.visible = false
	var s = sprite_size
	cs_triangle.polygon[0] = Vector2(-s.x / 2, -s.y / 2)
	cs_triangle.polygon[1] = Vector2(s.x / 2, -s.y / 2)
	cs_triangle.polygon[2] = Vector2(-s.x / 2, s.y / 2)


func hit() -> int:
	_remaining_hit_count -= 1
	return _remaining_hit_count


func destroy(by: Ball) -> void:
	_remaining_hit_count = 0
	SignalHub.brick_hit.emit(self, by, true)
	queue_free()

"""
func _on_body_entered(body: Node) -> void:
	if body is Ball:
		_remaining_hit_count -= 1
		touched.emit(self)
		if _remaining_hit_count == 0:
			SignalHub.brick_hit.emit(self, body, true)
			queue_free()
		else:
			SignalHub.brick_hit.emit(self, body, false)
"""
