@tool
@icon("res://icons/cube.svg")
extends RigidBody2D
class_name SBO_Brick

@export var properties: BrickProperties = BrickProperties.new()

@onready var sprite: Sprite2D = $Sprite2D
@onready var cs_square: CollisionShape2D = $CS_Square
@onready var cs_triangle: CollisionPolygon2D = $CS_Triangle
@onready var cs_circle: CollisionShape2D = $CS_Circle

var _remaining_hit_count: int = 1
var _being_destroyed: bool = false


func _ready() -> void:
	properties.connect(&"property_changed", _on_property_changed)
	_remaining_hit_count = properties.hits
	_update_shape()


func _on_property_changed(prop_name: StringName) -> void:
	match prop_name:
		&"shape":
			_update_shape()


func _update_shape():
	if is_node_ready():
		sprite.frame = properties.shape
		cs_square.disabled = properties.shape > 7
		cs_triangle.disabled = properties.shape < 8 or properties.shape > 9
		cs_circle.disabled = properties.shape < 10
		cs_square.visible = not cs_square.disabled
		cs_triangle.visible = not cs_triangle.disabled
		cs_circle.visible = not cs_circle.disabled


"""
## Returns true if the Brick has been destroyed, false if it has only been hit.
func hit_by_ball(force: int = 1) -> bool:
	if is_breakable and can_be_destroyed_by_ball:
		remaining_hit_count = max(0, remaining_hit_count - force)
		if not remaining_hit_count:
			destroy()
			return true
	return false
"""

func destroy(play_sound: bool = true, can_provide_item: bool = true) -> bool:
	if _being_destroyed:
		return false
	_being_destroyed = true

	if play_sound:
		# The Brick is not freed right now to let the AudioStreamPlayer2D the time to finish.
		#$AudioDestroyed.play()
		# But we want the Brick to be visually destroyed:
		# So we disable collision:
		collision_layer = 0
		collision_mask = 0
		# And remove the Sprite2D
		remove_child($Sprite2D)
	else:
		queue_free()
	return true


func _on_audio_destroyed_finished() -> void:
	# When the "destroyed" audio is finished, we can really free the Brick.
	queue_free()
