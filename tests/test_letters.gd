extends Node2D

@onready var ball: Ball = $Ball


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for b in find_children("Button*", "Button", true, false):
		b.connect(&"pressed", _on_button_pressed.bind(b))


func _on_button_pressed(b: Button) -> void:
	ball.teleport_to(b.position + b.size / 2)
