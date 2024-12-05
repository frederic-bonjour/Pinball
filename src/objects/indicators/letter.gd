@tool
class_name IndicatorLetter
extends Control

const color_off: Color = Color(1, 1, 1, 0.3)

@export var letter: String:
	set(v):
		letter = v
		if is_node_ready():
			label.text = letter

@export var color_on: Color:
	set(v):
		color_on = v
		if is_node_ready():
			point_light.color = color_on

@export var lit: bool = true:
	set(v):
		lit = v
		if is_node_ready():
			sprite.modulate = color_on if lit else color_off
			label.modulate = color_on if lit else color_off
			point_light.enabled = lit


@onready var label = %Label
@onready var point_light: PointLight2D = $PointLight2D
@onready var sprite: Sprite2D = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	lit = lit
	color_on = color_on
	letter = letter
