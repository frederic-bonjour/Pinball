@tool
class_name LetterIndicatorGroup
extends Control

@export_group("Layout & Colors")
## The letters in this group.
@export var letters: String:
	set(v):
		letters = v
		_update_letters()

## The colors for the letters, in the same order.
## If size is less than the number of letters,
## the pingpong() function is used to get the other colors.
@export var colors: Array[Color]:
	set(v):
		colors = v
		_update_letters()

## If [member colors]'s size is less than the number of letters, define how to
## reuse the provided [member colors]:[br][br]
## [b]repeat[/b]: repeat the [member colors] from the start.[br][br]
## [b]repeat_last[/b]: repeat only the last value of [member colors] for all the remaining letters.[br][br]
## [b]pingpong[/b]: the [method pingpong] function is used for each letter to pick its color from [member colors].
@export_enum("repeat", "repeat_last", "pingpong") var colors_cycling: String = "pingpong"

## The offset between each letter.
@export var offset: Vector2:
	set(v):
		offset = v
		_update_positions()

@export_group("Completion")
@export var blink_count: int = 4
@export var blink_delay: float = 0.1
@export var redoable: bool = true
@export var reset_on_ball_lost: bool = false


const LetterIndicatorScene = preload("res://src/objects/indicators/letter.tscn")
const LETTER_SIZE: Vector2 = Vector2(70, 70)

var _lit_count: int = 0
var _letter_nodes: Array[IndicatorLetter] = []

var is_completed: bool:
	get: return _lit_count == letters.length()


# Called when the node enters the scene tree for the first time.
func _ready():
	_update_letters()
	_update_positions()
	_update_colors()
	if reset_on_ball_lost:
		SignalHub.ball_lost.connect(_do_reset_on_ball_lost)


func _do_reset_on_ball_lost(_ball: Ball) -> void:
	reset()


func _update_letters() -> void:
	# Remove letters.
	for node in find_children("Letter_*", "", false, false):
		node.name += "_OLD"
		remove_child(node)
	_letter_nodes.clear()

	var letter_occurences := {}
	if not letters.is_empty():
		for i in range(letters.length()):
			var letter = letters[i]
			if not letter_occurences.has(letter):
				letter_occurences[letter] = 1
			else:
				letter_occurences[letter] += 1
			var node_name = "Letter_%s%d" % [letter, letter_occurences[letter]]
			var node = LetterIndicatorScene.instantiate()
			node.letter = letter
			node.name = node_name
			node.connect(&"ball_entered", _ball_entered.bind(node))
			node.lit = false
			node.position = offset * i
			_letter_nodes.append(node)
			add_child(node)
		size = (letters.length() - 1) * offset + LETTER_SIZE
	else:
		size.x = 0
		size.y = 0


func _update_positions() -> void:
	for i in range(_letter_nodes.size()):
		var node: IndicatorLetter = _letter_nodes[i]
		node.position = offset * i


func _update_colors() -> void:
	if colors and not colors.is_empty():
		for i in range(_letter_nodes.size()):
			var node: IndicatorLetter = _letter_nodes[i]
			match colors_cycling:
				&"repeat":
					node.color_on = colors[i % colors.size()]
				&"repeat_last":
					node.color_on = colors[min(i, colors.size() - 1)]
				&"pingpong":
					node.color_on = colors[pingpong(i, colors.size() - 1)]


func _ball_entered(_ball: Ball, letter: IndicatorLetter) -> void:
	if not letter.lit:
		letter.lit = true
		SignalHub.letter_group_letter_lit.emit(self, letter)
		_lit_count += 1
		if is_completed:
			_blink()


func _blink() -> void:
	for i in range(blink_count * 2):
		for l in _letter_nodes:
			l.lit = i % 2 > 0
		await get_tree().create_timer(blink_delay).timeout
	SignalHub.letter_group_completed.emit(self)
	if redoable:
		reset()


func reset() -> void:
	_lit_count = 0
	for l in _letter_nodes:
		l.lit = false
