extends Node2D

@onready var light_occluder_2d = $StaticBody2D/LightOccluder2D
@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D
@onready var kick_back: KickBack = $KickBack


func _ready() -> void:
	SignalHub.kickback_loading.connect(_kickback_loading)
	light_occluder_2d.occluder.polygon = collision_polygon_2d.polygon


func _kickback_loading(kickback, value):
	if kickback == %KickBack:
		%ProgressBar.value = value


func load_ball(ball: Ball) -> void:
	kick_back.load_ball(ball)
