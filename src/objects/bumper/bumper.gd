@tool
class_name Bumper
extends RigidBody2D

@export var max_strength: int = 500
@export var score: int = 100

@onready var collision_shape = %CollisionShape
@onready var sprite: Sprite2D = $Sprite2D

const BUMPER_WAVE_SCENE = preload("res://src/objects/bumper/bumper_wave.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(&"bumpers")


func _on_body_entered(body):
	if body is Ball:
		# FIXME Enhance bounce
		#body.linear_velocity = body.linear_velocity.normalized() * 1500
		add_child(BUMPER_WAVE_SCENE.instantiate())
