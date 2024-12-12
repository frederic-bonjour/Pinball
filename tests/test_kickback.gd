extends Node2D

@onready var ball: Ball = %Ball
@onready var kick_back: KickBack = %KickBack
@onready var state_label: Label = %State
@onready var progress_bar = %ProgressBar
@onready var gravity_area_2d: Area2D = $GravityArea2D



func _on_eject_pressed() -> void:
	kick_back.eject()


func _on_eject_button_button_down() -> void:
	Input.action_press(&"launch")


func _on_eject_button_button_up() -> void:
	Input.action_release(&"launch")


func _on_kick_back_state_changed(state: StringName) -> void:
	if is_node_ready():
		state_label.text = "State: %s" % state


func _on_kick_back_loading(value):
	progress_bar.value = value


func _on_inverse_gravity_button_pressed() -> void:
	gravity_area_2d.gravity_direction.y = -$SpinBox.value


func _on_gravity_area_2d_body_entered(body: Node2D) -> void:
	gravity_area_2d.gravity_direction.y = 2


func _on_gravity_area_2d_body_exited(body: Node2D) -> void:
	gravity_area_2d.gravity_direction.y = 2
