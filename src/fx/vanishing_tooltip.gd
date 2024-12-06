class_name VanishingTooltip
extends Label

@export var duration: float = 1.2
@export var distance: Vector2 = Vector2(0, -100)


func _ready():
	theme_type_variation = &"VanishingTooltip"
	top_level = true
	z_index = 100


func _process(_delta: float) -> void:
	# The "size" is really reliable here and not before,
	# so I use to here to compute the pivot_offset and the correct position.
	pivot_offset = size / 2.0
	position -= pivot_offset
	# Then I create the tween for the animation...
	var t := create_tween().set_ease(Tween.EASE_OUT)
	t.tween_property(self, "position", position + distance, duration)
	t.parallel().tween_property(self, "scale", Vector2(1.2, 0.8), duration)
	t.parallel().tween_property(self, "modulate:a", 0.0, duration)
	t.tween_callback(queue_free)
	# ... and finally, I stop the process of this node (the Tween will keep running).
	set_process(false)


func offset_y(y: int) -> VanishingTooltip:
	position.y += y
	return self


static func make_text(content: StringName, pos: Vector2, color: Color = Color.WHITE) -> VanishingTooltip:
	var vt = VanishingTooltip.new()
	vt.text = content
	vt.position =  pos
	vt.modulate = color
	return vt


static func make_int(value: int, pos: Vector2, color: Color = Color.WHITE) -> VanishingTooltip:
	return make_text(str(value), pos, color)
