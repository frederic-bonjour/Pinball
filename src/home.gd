extends Control


func _on_play_button_pressed():
	SceneManager.start_game()


func _on_quit_button_pressed():
	get_tree().quit()
