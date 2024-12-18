@tool
extends Button

@export var icon_texture: Texture2D:
	set(v):
		icon_texture = v
		if is_node_ready():
			$HBoxContainer/Icon.texture = icon_texture

@export var icon_modulate: Color = Color.BLACK:
	set(v):
		icon_modulate = v
		if is_node_ready():
			$HBoxContainer/Icon.modulate = icon_modulate

@export var separation: int = 20:
	set(v):
		separation = v
		if is_node_ready():
			$HBoxContainer.add_theme_constant_override(&"separation", v)

@export var label: String:
	set(v):
		label = v
		if is_node_ready():
			waving_text.text = v

@export var letter_spacing: int = 0:
	set(v):
		letter_spacing = v
		if is_node_ready():
			waving_text.letter_spacing = v

@onready var waving_text = $HBoxContainer/WavingText


# Called when the node enters the scene tree for the first time.
func _ready():
	icon_texture = icon_texture
	icon_modulate = icon_modulate
	letter_spacing = letter_spacing
	label = label
	_on_focus_exited()


func _on_focus_exited():
	material.set_shader_parameter("hover", false)


func _on_focus_entered():
	material.set_shader_parameter("hover", true)
	waving_text.waving = true
