class_name BoardObjectLegoLauncher
extends Node2D

@onready var cog_chain = $CogChain
@onready var kick_back = $CogChain/Cog1_LG/KickBack


var _angle := 15.0


func _ready() -> void:
	for cog in cog_chain.find_children("*", "Cog", false):
		BodySpriteShadow.add_to_body(cog, Vector2(10, 10))


func _process(_delta: float) -> void:
	#if kick_back.is_loaded:
		if Input.is_action_pressed(&"flipper_left"):
			_angle = _angle - 1.0
		if Input.is_action_pressed(&"flipper_right"):
			_angle += 1.0
		_angle = clamp(_angle, 15, 165)
		cog_chain.rotate_cog(_angle)


# Called when the node enters the scene tree for the first time.
func load_ball(ball: Ball):
	ball.teleport_to(global_position)
