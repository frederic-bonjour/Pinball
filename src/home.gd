extends Control


func _on_play_button_pressed():
	SceneManager.start_game()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_quit_button_mouse_entered() -> void:
	var qb: Button = $VBoxContainer/QuitButton
	var vt := VanishingTooltip.make_text_anchored("You're leaving soon?", $VBoxContainer/QuitButton, HORIZONTAL_ALIGNMENT_RIGHT, VERTICAL_ALIGNMENT_CENTER, Vector2(20, 0))
	vt.add_theme_color_override(&"font_color", Color.WHITE)
	vt.distance = Vector2(100, 0)
	add_child(vt)
