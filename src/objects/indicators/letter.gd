@tool
class_name IndicatorLetter
extends Control

signal ball_entered(ball: Ball)

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
			light.color = color_on

@export var lit: bool = true:
	set(v):
		lit = v
		if is_node_ready():
			sprite.modulate = color_on if lit else color_off
			label.modulate = color_on if lit else color_off
			light.enabled = lit


@onready var label = %Label
@onready var light: PointLight2D = $Light
@onready var sprite: Sprite2D = $Sprite
@onready var area: Area2D = $Area
@onready var collision_shape: CollisionShape2D = $Area/CollisionShape


# Called when the node enters the scene tree for the first time.
func _ready():
	label.theme_type_variation = &"IndicatorLetter"
	lit = lit
	color_on = color_on
	letter = letter
	area.position = size / 2
	light.position = size / 2
	(collision_shape.shape as RectangleShape2D).size = size


func _on_letter_body_entered(body: Node2D) -> void:
	if body is Ball:
		ball_entered.emit(body)
