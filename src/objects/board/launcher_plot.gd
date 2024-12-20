@tool
class_name LauncherPlot
extends Node2D

@export var background_color: Color = Color.WHITE:
	set(v):
		background_color = v
		if $Polygon2D:
			$Polygon2D.color = background_color

@onready var launcher = %Launcher
@onready var rotate_on_flip = $Launcher/RotateOnFlip


func _ready():
	background_color = background_color


func reset_position() -> void:
	await rotate_on_flip.reset()


func load_ball(ball: Ball) -> void:
	launcher.load_ball(ball)
