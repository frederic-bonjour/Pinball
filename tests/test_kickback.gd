extends Node2D

@onready var ball: Ball = %Ball
@onready var kick_back: KickBack = %KickBack
@onready var state_label: Label = $State


func _on_eject_pressed() -> void:
	kick_back.eject()


func _on_eject_button_button_down() -> void:
	Input.action_press(&"launch")


func _on_eject_button_button_up() -> void:
	Input.action_release(&"launch")


func _on_kick_back_state_changed(state: StringName) -> void:
	if is_node_ready():
		state_label.text = "State: %s" % state
