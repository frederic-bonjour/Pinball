extends BrickGroup

var _initial_position: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	_initial_position = position


var _t := 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = _initial_position + Vector2(cos(_t), sin(_t * 0.783)) * 5.0
	_t += delta * 9.0
