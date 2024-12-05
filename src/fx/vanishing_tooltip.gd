class_name VanishingTooltip
extends Label

@export var duration: float = 1.2
@export var distance: Vector2 = Vector2(0, -100)


func attach_to(node: Node) -> void:
	node.add_child(self)


func _ready():
	# Position the tooltip: horizontally centered and vertically above its parent.
	position.x -= size.x / 2.0
	position.y -= size.y / 2.0

	var t := create_tween().set_ease(Tween.EASE_OUT)
	t.tween_property(self, "position", position + distance, duration)
	t.parallel().tween_property(self, "scale", Vector2(1.2, 0.8), duration)
	t.parallel().tween_property(self, "modulate:a", 0.0, duration)
	t.tween_callback(queue_free)


func offset_y(y: int) -> VanishingTooltip:
	position.y += y
	return self


static func make_text(content: StringName, node: Node2D, color: Color = Color.WHITE) -> VanishingTooltip:
	var vt = VanishingTooltip.new()
	vt.text = content
	vt.position = node.global_position # FIXME
	vt.modulate = color
	return vt


static func make_int(value: int, node: Node2D, color: Color = Color.WHITE) -> VanishingTooltip:
	return make_text("%+d" % value, node, color)
