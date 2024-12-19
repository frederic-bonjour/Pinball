## A class to create vanishing tooltips.
## Such a tooltip slightly moves and vanishes,
## very usefull to display a score that has just been earned or health that has just been lost.
## Use the [i]theme_type_variation[/i] [code]VanishingTooltip[/code] to style it
## or set another [i]theme_type_variation[/i] of your own.
class_name VanishingTooltip
extends Label

## The lifetime of the tooltip.
@export var duration: float = 1.2

## The distance that will be covered by the tooltip before it vanishes for ever.
@export var distance: Vector2 = Vector2(0, -100)

const ANCHOR_LEFT := 1
const ANCHOR_CENTER := 2
const ANCHOR_RIGHT := 4
const ANCHOR_TOP := 1
const ANCHOR_BOTTOM := 4

var _anchor_node
var _anchor_h: HorizontalAlignment = HORIZONTAL_ALIGNMENT_CENTER
var _anchor_v: VerticalAlignment = VERTICAL_ALIGNMENT_CENTER


func _ready():
	if theme_type_variation.is_empty():
		theme_type_variation = &"VanishingTooltip"
	top_level = true
	z_index = 100


func _process(_delta: float) -> void:
	# The "size" is really reliable here and not before,
	# so we can use it here to compute the pivot_offset and the correct position.
	pivot_offset = size / 2.0

	if _anchor_node:
		# When using the anchor mode,
		# the position that might have already been set is used as an offset.
		position += _anchor_node.global_position
		match _anchor_h:
			HORIZONTAL_ALIGNMENT_CENTER: position.x += _anchor_node.size.x / 2.0
			HORIZONTAL_ALIGNMENT_RIGHT: position.x += _anchor_node.size.x
		match _anchor_v:
			VERTICAL_ALIGNMENT_CENTER: position.y += (_anchor_node.size.y - size.y) / 2.0
			VERTICAL_ALIGNMENT_BOTTOM: position.y += _anchor_node.size.y - size.y
	else:
		position -= pivot_offset

	# Then, create the tween for the animation.
	var t := create_tween().set_ease(Tween.EASE_OUT)
	t.tween_property(self, "position", position + distance, duration)
	t.parallel().tween_property(self, "scale", Vector2(1.2, 0.8), duration)
	t.parallel().tween_property(self, "modulate:a", 0.0, duration)
	t.tween_callback(queue_free)
	# ... and finally, I stop the process of this node (the Tween will keep running).
	set_process(false)


## Anchors this [VanishingTooltip] to a Node2D or a Control node.
func anchor_to(node: Variant, horizontal: HorizontalAlignment, vertical: VerticalAlignment) -> VanishingTooltip:
	assert(node is Node2D or node is Control, "'node' must be a Node2D or a Control derived Object.")
	_anchor_node = node
	_anchor_h = horizontal
	_anchor_v = vertical
	return self


func offset_y(y: int) -> VanishingTooltip:
	position.y += y
	return self


## Builds a [VanishingTooltip] instance based on a text at the position [param pos].
static func make_text(content: StringName, pos: Vector2 = Vector2.ZERO) -> VanishingTooltip:
	var vt = VanishingTooltip.new()
	vt.text = content
	vt.position =  pos
	return vt

## Builds a [VanishingTooltip] instance based on an integer value at the position [param pos].
static func make_int(value: int, pos: Vector2) -> VanishingTooltip:
	return make_text(str(value), pos)

## Builds a [VanishingTooltip] instance based on an integer value, anchored to a Node2D or Control node.
static func make_int_anchored(value: int, node: Variant, horizontal: HorizontalAlignment, vertical: VerticalAlignment, offset: Vector2 = Vector2.ZERO) -> VanishingTooltip:
	return make_int(value, offset).anchor_to(node, horizontal, vertical)

## Builds a [VanishingTooltip] instance based on a text, anchored to a Node2D or Control node.
static func make_text_anchored(content: StringName, node: Variant, horizontal: HorizontalAlignment, vertical: VerticalAlignment, offset: Vector2 = Vector2.ZERO) -> VanishingTooltip:
	return make_text(content, offset).anchor_to(node, horizontal, vertical)
