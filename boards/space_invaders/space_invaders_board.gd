extends PinballBoard

@onready var letter_group_space: LetterIndicatorGroup = %LetterGroup_SPACE

func _board_ready() -> void:
	pass


func _brick_group_cleared(group_node: BrickGroup) -> void:
	super._brick_group_cleared(group_node)
	check_board_complete()


func check_board_complete() -> void:
	if all_brick_groups_cleared and letter_group_space.is_completed:
		print_debug("Game over!")
		get_tree().quit()


func _on_letter_group_completed(_group: LetterIndicatorGroup):
	check_board_complete()
