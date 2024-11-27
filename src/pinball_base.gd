extends Node2D

@onready var camera: Camera2D = %Camera
@onready var ball: Ball = %Ball


func _process(_delta: float):
	_process_inputs()
	_update_camera()


func _process_inputs() -> void:
	if Input.is_action_just_pressed(&"flipper_left"):
		get_tree().call_group(&"flipper_left", &"activate")
	if Input.is_action_just_released(&"flipper_left"):
		get_tree().call_group(&"flipper_left", &"deactivate")
	if Input.is_action_just_pressed(&"flipper_right"):
		get_tree().call_group(&"flipper_right", &"activate")
	if Input.is_action_just_released(&"flipper_right"):
		get_tree().call_group(&"flipper_right", &"deactivate")


func _update_camera() -> void:
	camera.position.y = clamp(remap(ball.position.y, -300, -2000, -540, -1620), -1620, -540)


const BALL_INITIAL_POSITION: Vector2 = Vector2(685, -520)


func _on_lose_ball_area_body_entered(body: Node2D) -> void:
	if body is Ball:
		body.teleport_to(BALL_INITIAL_POSITION)
