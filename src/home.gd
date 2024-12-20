extends Control

func _ready():
	for b in $PlayBoardButtons.find_children("*", "Button", false):
		b.connect(&"pressed", _play_board.bind(b.name.substr(5)))
func _on_play_button_pressed():
	SceneManager.start_game()


func _play_board(board_name: StringName) -> void:
	SceneManager.start_game(board_name)


func _on_quit_button_pressed():
	get_tree().quit()


func _on_quit_button_mouse_entered() -> void:
	"""
	var qb: Button = $VBoxContainer/QuitButton
	var vt := VanishingTooltip.make_text_anchored("Already leaving?", $VBoxContainer/QuitButton, HORIZONTAL_ALIGNMENT_RIGHT, VERTICAL_ALIGNMENT_CENTER, Vector2(0, -20))
	vt.add_theme_color_override(&"font_color", Color.WHITE)
	vt.distance = Vector2(0, -100)
	add_child(vt)
	"""


func _on_button_mouse_entered():
	SfxMusicManager.play(&"button_hover")
