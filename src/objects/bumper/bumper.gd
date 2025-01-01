@tool
class_name Bumper
extends RigidBody2D

@export var max_strength: int = 500
@export var score: int = 100
@export var radius: int = 50:
	set(v):
		radius = v
		_update_radius()

@onready var collision_shape = %CollisionShape
@onready var sprite: Sprite2D = $Sprite
@onready var light = $Light

const BUMPER_WAVE_SCENE = preload("res://src/objects/bumper/bumper_wave.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(&"bumpers")
	add_to_group(&"bodies_with_shadow")
	_update_radius()


func _update_radius() -> void:
	if is_node_ready():
		collision_shape.shape.radius = radius
		var s = radius / 50.0
		sprite.scale = Vector2(s, s)


func _process(delta: float) -> void:
	_light_progress = move_toward(_light_progress, 0.0, delta * 10.0)
	light.energy = ease(_light_progress, 0.4) * 4
	light.enabled = light.energy >= 0.1


var _light_progress := 0.0

func _on_body_entered(body):
	if body is Ball:
		# FIXME Enhance bounce
		#body.linear_velocity = body.linear_velocity.normalized() * 1500
		var wave = BUMPER_WAVE_SCENE.instantiate()
		wave.scale = sprite.scale
		add_child(wave)
		_light_progress = 1.0
		
