extends Node2D


func _ready() -> void:
	SignalHub.kickback_loading.connect(_kickback_loading)


func _kickback_loading(kickback, value):
	if kickback == %Launcher:
		%ProgressBar.value = value
