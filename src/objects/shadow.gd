class_name BodySpriteShadow
extends Sprite2D

const DEFAULT_OFFSET := Vector2(0, 15)

@export var parent_sprite: Sprite2D
@export var shadow_offset: Vector2 = DEFAULT_OFFSET
@export var shadow_color: Color = Color(0, 0, 0, 0.4)
var _parent_body: Node2D


func _ready() -> void:
	#z_as_relative = false
	top_level = true
	_parent_body = get_parent()
	#show_behind_parent = true
	if parent_sprite:
		parent_sprite.z_index = 1
		z_index = 0
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


static func add_to_body(body: Node2D, _shadow_offset: Vector2 = DEFAULT_OFFSET) -> BodySpriteShadow:
	var s := BodySpriteShadow.new()
	s.shadow_offset = _shadow_offset
	if body is Sprite2D:
		s.parent_sprite = body
	else:
		s.parent_sprite = body.get_node_or_null("Sprite")
		if not s.parent_sprite:
			s.parent_sprite = body.get_node_or_null("Sprite2D")
	body.add_child(s)
	return s
