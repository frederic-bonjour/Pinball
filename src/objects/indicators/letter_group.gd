class_name IndicatorLetterGroup
extends Node

signal completed
signal letter_on(letter: IndicatorLetter)

@export var blink_count: int = 4
@export var blink_delay: float = 0.1

var _lit_count: int = 0
var _letters: Array[Node]


# Called when the node enters the scene tree for the first time.
func _ready():
	_letters = get_parent().find_children("*", "IndicatorLetter", true, false)
	for l in _letters:
		l.connect(&"body_entered", _ball_entered.bind(l))
		l.lit = false


func _ball_entered(_ball: Ball, letter: IndicatorLetter) -> void:
	if not letter.lit:
		letter.lit = true
		letter_on.emit(letter)
		_lit_count += 1
		if _lit_count == _letters.size():
			_blink()


func _blink() -> void:
	for i in range(blink_count * 2):
		for l in _letters:
			l.lit = i % 2 > 0
		await get_tree().create_timer(blink_delay).timeout
	completed.emit()
	reset()


func reset() -> void:
	_lit_count = 0
	for l in _letters:
		l.lit = false
