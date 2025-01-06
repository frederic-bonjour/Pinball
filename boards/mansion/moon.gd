@tool
extends Sprite2D


var _initial_position: Vector2
var _new_position: Vector2

var progress: float = 0.0:
	set(v):
		progress = v
		_new_position.y = remap(progress, 0.0, 1.0, _initial_position.y, -1200) # TODO
		set_process(_new_position.y != position.y)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_initial_position = position
	_new_position = _initial_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.y != _new_position.y:
		position.y = move_toward(position.y, _new_position.y, delta * 15)
		var s = remap(position.y, -1200, _initial_position.y, 1.4, 1.0)
		scale = Vector2(s, s)
	else:
		set_process(false)
