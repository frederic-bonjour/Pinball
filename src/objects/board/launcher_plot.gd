class_name LauncherPlot
extends Node2D

@onready var launcher = %Launcher
@onready var rotate_on_flip = $Launcher/RotateOnFlip

func reset_position() -> void:
	await rotate_on_flip.reset()


func load_ball(ball: Ball) -> void:
	launcher.load_ball(ball)
