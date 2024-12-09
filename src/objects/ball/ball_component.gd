class_name BallComponent
extends Node

var _ball: Ball

func _enter_tree():
	_ball = get_parent()
	_component_added()

func _exit_tree():
	_component_removed()

#region Overridable methods
func _component_added() -> void:
	pass

func _component_removed() -> void:
	pass
#endregion
