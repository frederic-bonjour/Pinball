@tool
extends Button

@export_group("Icon")
## The icon's texture.
@export var icon_texture: Texture2D:
	set(v):
		icon_texture = v
		if is_node_ready():
			$HBoxContainer/Icon.texture = icon_texture
			$HBoxContainer/Icon.visible = icon_texture != null

## The icon's color modulate.
@export var icon_modulate: Color = Color.BLACK:
	set(v):
		icon_modulate = v
		if is_node_ready():
			$HBoxContainer/Icon.modulate = icon_modulate

@export_group("Text")
## The text to be displayed in the button.
@export var label: String:
	set(v):
		label = v
		if is_node_ready():
			waving_text.text = v

## Space between letters in pixels. May be negative.
@export var letter_spacing: int = 0:
	set(v):
		letter_spacing = v
		if is_node_ready():
			waving_text.letter_spacing = v

@export_group("Layout")
## The separation between the icon and the label, in pixels.
@export var separation: int = 20:
	set(v):
		separation = v
		if is_node_ready():
			$HBoxContainer.add_theme_constant_override(&"separation", v)

## Corner radius in pixels.
@export var corner_radius: int = 10:
	set(v):
		corner_radius = v
		if is_node_ready():
			_update_stylebox()

## Drop shadow size in pixels.
@export var shadow_size: int = 20:
	set(v):
		shadow_size = v
		if is_node_ready():
			_update_stylebox()

## The scale to use when button is focused.
@export var hover_scale: Vector2 = Vector2(1.05, 1.05)

@onready var waving_text = $HBoxContainer/WavingText


# Called when the node enters the scene tree for the first time.
func _ready():
	_update_stylebox()
	icon_texture = icon_texture
	letter_spacing = letter_spacing
	label = label
	pivot_offset = size / 2.0
	_on_focus_exited()


func _update_stylebox() -> void:
	var sb := StyleBoxFlat.new()
	sb.corner_radius_bottom_left = corner_radius
	sb.corner_radius_bottom_right = corner_radius
	sb.corner_radius_top_left = corner_radius
	sb.corner_radius_top_right = corner_radius
	sb.bg_color = Color.WHITE
	sb.shadow_size = shadow_size
	add_theme_stylebox_override(&"normal", sb)
	add_theme_stylebox_override(&"hover", sb)

var dest_scale: Vector2 = Vector2.ONE

func _on_focus_exited():
	material.set_shader_parameter("hover", false)
	$HBoxContainer.modulate = get_theme_color(&"font_color")
	dest_scale = Vector2.ONE


func _on_focus_entered():
	material.set_shader_parameter("hover", true)
	waving_text.waving = true
	$HBoxContainer.modulate = get_theme_color(&"font_hover_color")
	dest_scale = hover_scale


func _process(delta: float) -> void:
	scale = scale.move_toward(dest_scale, delta)


func _validate_property(property: Dictionary) -> void:
	match property.name:
		&"text", &"icon", &"flat":
			property.usage = PROPERTY_USAGE_NO_EDITOR
