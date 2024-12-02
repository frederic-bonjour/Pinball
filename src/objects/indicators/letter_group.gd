class_name IndicatorLetterGroup
extends Node2D

signal completed
signal letter_on(letter: IndicatorLetter)

var _lit_count: int = 0
var _letters: Array[Node]


# Called when the node enters the scene tree for the first time.
func _ready():
	_letters = find_children("*", "IndicatorLetter", true, false)
	for l in _letters:
		l.connect(&"body_entered", _ball_entered.bind(l))
		l.lit = false


func _ball_entered(ball, letter: IndicatorLetter) -> void:
	if not letter.lit:
		letter.lit = true
		letter_on.emit(letter)
		_lit_count += 1
		if _lit_count == _letters.size():
			completed.emit()
			reset()


func reset() -> void:
	_lit_count = 0
	for l in _letters:
		l.lit = false
