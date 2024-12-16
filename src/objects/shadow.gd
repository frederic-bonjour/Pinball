class_name BodySpriteShadow
extends Sprite2D

@export var parent_sprite: Sprite2D
@export var shadow_offset: Vector2 = Vector2(0, 15)
@export var shadow_color: Color = Color(0, 0, 0, 0.4)
var _parent_body: Node2D


func _ready() -> void:
	z_as_relative = false
	z_index = -10
	top_level = true
	_parent_body = get_parent()
	if parent_sprite:
		texture = parent_sprite.texture
		hframes = parent_sprite.hframes
		vframes = parent_sprite.vframes
		modulate = shadow_color
		flip_h = parent_sprite.flip_h
		flip_v = parent_sprite.flip_v
		scale = parent_sprite.scale
		if flip_h: shadow_offset.x *= -1
		if flip_v: shadow_offset.y *= -1
	set_process(parent_sprite != null)


func _process(_delta: float) -> void:
	var a: float = -_parent_body.rotation
	rotation = -a
	global_position = parent_sprite.global_position + shadow_offset
	frame = parent_sprite.frame


static func add_to_body(body: Node2D) -> BodySpriteShadow:
	var s := BodySpriteShadow.new()
	s.parent_sprite = body.get_node_or_null("Sprite")
	if not s.parent_sprite:
		s.parent_sprite = body.get_node_or_null("Sprite2D")
	body.add_child(s)
	return s
