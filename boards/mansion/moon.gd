extends Sprite2D

signal arrived

var _initial_position: Vector2
var _new_position: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_initial_position = position
	_new_position = _initial_position


func rise(amount: float = 40.0) -> void:
	if position.y > -1200:
		_new_position.y -= amount
		set_process(_new_position.y != position.y)
	else:
		arrived.emit()
		set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.y != _new_position.y:
		position.y = move_toward(position.y, _new_position.y, delta * 5)
		var s = remap(position.y, -1200, _initial_position.y, 1.4, 1.0)
		scale = Vector2(s, s)
	else:
		set_process(false)
