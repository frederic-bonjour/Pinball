class_name Accelerator
extends Area2D

@export var strength: float = 3


func _ready():
	gravity_direction = Vector2.from_angle(rotation) * strength


func _on_body_entered(_body):
	$StopAnimationTimer.stop()
	$AnimationPlayer.play(&"running")


func _on_body_exited(_body):
	$StopAnimationTimer.start()


func _on_stop_animation_timer_timeout():
	$AnimationPlayer.stop()
