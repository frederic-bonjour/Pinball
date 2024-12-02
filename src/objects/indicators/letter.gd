@tool
class_name IndicatorLetter
extends Node2D

@export var letter: String:
	set(v):
		letter = v
		if is_node_ready():
			label.text = letter

@export var color_on: Color:
	set(v):
		color_on = v
		if is_node_ready():
			polygon.self_modulate = color_on if lit else Color.GRAY

@export var lit: bool = true:
	set(v):
		lit = v
		if is_node_ready():
			polygon.self_modulate = color_on if lit else Color.GRAY


@onready var label = %Label
@onready var polygon = %Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready():
	lit = lit
	color_on = color_on
	letter = letter
