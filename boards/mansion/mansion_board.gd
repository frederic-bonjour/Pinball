extends PinballBoard

@onready var launcher: BallLauncher = $Launcher
@onready var windows_floor3_ap: AnimationPlayer = %WindowsFloor3AP


var quest_manager := QuestManager.new()


func _board_ready():
	quest_manager.add_quest(&"LIGHTS", 1)
	quest_manager.add_quest(&"MOON", 10)
	_board_load_ball_in_launcher(new_ball())


func _board_load_ball_in_launcher(ball: Ball):
	launcher.load_ball(ball)


func _on_ball_saver_changed(_active: bool):
	pass


func _board_process(_delta: float) -> void:
	pass


func _board_on_letter_group_completed(group: LetterIndicatorGroup, _ball: Ball):
	match group.letters:
		&"MOON":
			$Moon.progress = quest_manager.quest_add_step(&"MOON")
		&"LIGHTS":
			quest_manager.quest_add_step(&"LIGHTS")
			if quest_manager.quest_is_completed(&"LIGHTS"):
				windows_floor3_ap.play(&"completed")


func _is_board_complete():
	return all_brick_groups_cleared and quest_manager.check_all_quests_completed()


func _on_ghost_brick_hit_in_group(_group: BrickGroup):
	SfxMusicManager.play(&"ghost")
	var t := create_tween()
	t.tween_property($Ghost, "modulate:a", 0.2, 0.2).from(1.0)
