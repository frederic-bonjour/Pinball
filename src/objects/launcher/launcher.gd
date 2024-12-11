class_name BallLauncher
extends Node2D

@export var strength: int = 380000

@onready var kick_back: KickBack = $KickBack


func _ready() -> void:
	SignalHub.kickback_loading.connect(_kickback_loading)
	kick_back.strength = strength


func _kickback_loading(kickback, value):
	if kickback == %KickBack:
		%ProgressBar.value = value


func load_ball(ball: Ball) -> void:
	kick_back.load_ball(ball)
