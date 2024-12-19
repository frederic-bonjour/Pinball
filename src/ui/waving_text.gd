@tool
class_name WavingText
extends HBoxContainer

@export var text: String:
	set(v):
		text = v
		if is_node_ready():
			_update_label()

@export var letter_spacing: int = 0:
	set(v):
		letter_spacing = v
		if is_node_ready():
			add_theme_constant_override(&"separation", v)

@export var one_shot: bool = false
@export var waving: bool = true:
	set(v):
		waving = v
		a = 0.0
		set_process(v)

@export_range(0, 200) var wave_amplitude: int = 5
@export_range(1, 20) var speed: int = 10


func _ready():
	letter_spacing = letter_spacing
	text = text


func _update_label() -> void:
	while get_child_count() > 0:
		remove_child(get_child(0))
	for l in text:
		var ln := Label.new()
		ln.add_theme_color_override(&"font_color", Color.WHITE)
		ln.text = l
		add_child(ln)


var last_ts: int = 0
var ticks: float = 0.0
var a: float = 0.0

func _process(delta: float) -> void:
	a = move_toward(a, TAU, delta * speed)
	if a >= TAU:
		a = 0.0
		set_process(not one_shot)

	var count := get_child_count()
	var interval := PI / (count - 1)
	var offset := 0.0
	for lbl in get_children():
		lbl.position.y = -clamp((sin(a - offset)), 0, 1) * wave_amplitude
		offset += interval
