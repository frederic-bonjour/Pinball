class_name PinballBoard
extends Node2D

@export var theme: BoardTheme

@onready var camera: Camera2D = %Camera
@onready var ball: Ball = %Ball


func _ready() -> void:
	pass


func _process(_delta: float):
	_process_inputs()
	_update_camera()
	var t := get_tree()
	t.set_group(&"bricks", "modulate", theme.bricks_color)
	t.set_group(&"slingshots", "modulate", theme.slingshots_color)
	t.set_group(&"bumpers", "modulate", theme.bumpers_color)
	t.set_group(&"flippers", "modulate", theme.flippers_color)
	t.set_group(&"balls", "modulate", theme.balls_color)
	t.set_group(&"walls", "modulate", theme.walls_color)


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
	#FIXME Hard-coded values
	camera.position.y = clamp(ball.position.y, -2700, -540)


const BALL_INITIAL_POSITION: Vector2 = Vector2(1380, -695)


func _on_lose_ball_area_body_entered(body: Node2D) -> void:
	if body is Ball:
		SignalHub.ball_lost.emit(body)
		body.teleport_to(BALL_INITIAL_POSITION)