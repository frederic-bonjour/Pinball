extends Control


@onready var canvas_layer = $TransitionCanvasLayer

var _current_scene_node: Node
var _current_board_name: StringName

var boards: Array[StringName]:
	get:
		if not boards:
			boards = []
			var cf := ConfigFile.new()
			cf.load("res://boards/boards.ini")
			for b in cf.get_value("boards", "order", []):
				boards.append(b)
		return boards


func nav_to_board(board_name: StringName, play_fade_out: bool = true) -> void:
	if play_fade_out:
		await fade_out()
	_load_scene("res://boards/%s/%s_board.tscn" % [board_name, board_name])
	_current_board_name = board_name


func has_next_board() -> bool:
	if not _current_board_name:
		return true
	var b := boards.find(_current_board_name)
	return b >= 0 and b < boards.size() - 1


func start_game(board_name: String = "") -> void:
	if board_name.is_empty():
		_current_board_name = &""
		next_board()
	else:
		nav_to_board(board_name)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"pause"):
		get_tree().paused = not get_tree().paused


func next_board(play_fade_out: bool = true) -> void:
	var b: int = 0
	if not _current_board_name.is_empty():
		b = boards.find(_current_board_name)
		if b >= 0 and b < boards.size() - 1:
			b += 1
	await nav_to_board(boards[b], play_fade_out)


func nav_home(play_fade_out: bool = true) -> void:
	if play_fade_out:
		await fade_out()
	_load_scene("res://src/home.tscn")


func _load_scene(scene_file: String) -> void:
	if _current_scene_node:
		remove_child(_current_scene_node)
		_current_scene_node.queue_free()

	var scene = load(scene_file)
	_current_scene_node = scene.instantiate()
	add_child(_current_scene_node)
	fade_in()


func fade_in() -> Signal:
	$AnimationPlayer.play(&"fade_in")
	return $AnimationPlayer.animation_finished


func fade_out() -> Signal:
	$AnimationPlayer.play(&"fade_out")
	return $AnimationPlayer.animation_finished


func immediate_in() -> void:
	$TransitionCanvasLayer/Overlay.material.set_shader_parameter(&"progress", 0.0)


func immediate_out() -> void:
	$TransitionCanvasLayer/Overlay.material.set_shader_parameter(&"progress", 1.0)
