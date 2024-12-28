class_name BoardObjectLegoLauncher
extends Node2D

@onready var Gear_chain = $GearBox
@onready var kick_back = $GearBox/Gear1_LG/KickBack


var _angle := 15.0


func _ready() -> void:
	for Gear in Gear_chain.find_children("*", "Gear", false):
		BodySpriteShadow.add_to_body(Gear, Vector2(10, 10))


func _process(_delta: float) -> void:
	if kick_back.is_loaded:
		if Input.is_action_pressed(&"flipper_left"):
			_angle = _angle - 1.0
		if Input.is_action_pressed(&"flipper_right"):
			_angle += 1.0
		_angle = clamp(_angle, 15, 165)
		Gear_chain.rotate_Gear(_angle)


# Called when the node enters the scene tree for the first time.
func load_ball(ball: Ball):
	ball.teleport_to(global_position)
