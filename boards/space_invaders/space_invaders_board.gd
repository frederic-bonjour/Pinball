extends PinballBoard


func _board_ready() -> void:
	pass


func _brick_group_cleared(group_node: BrickGroup) -> void:
	super._brick_group_cleared(group_node)
	check_board_complete()


func check_board_complete() -> void:
	if all_brick_groups_cleared:
		print_debug("Game over!")
		get_tree().quit()


func _on_letters_through_completed() -> void:
	for b in _balls:
		(b as Ball).add_component(BallComponentPassThrough.new())


func _on_letters_explose_completed() -> void:
	for b in _balls:
		(b as Ball).add_component(BallComponentExplosive.new())
