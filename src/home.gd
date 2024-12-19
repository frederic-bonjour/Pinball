extends Control


func _on_play_button_pressed():
	SceneManager.start_game()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_quit_button_mouse_entered() -> void:
	var qb: Button = $VBoxContainer/QuitButton
	var vt := VanishingTooltip.make_text("Déjà ?", qb.global_position + Vector2(qb.size.x + 90, qb.size.y / 2))
	vt.add_theme_color_override(&"font_color", Color.WHITE)
	vt.distance = Vector2(100, 0)
	add_child(vt)
