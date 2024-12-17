extends Control


func _ready():
	SfxMusicManager.add_db(&"common", load("res://src/sfxdb_global.tres"))
	SceneManager.immediate_out()
	SceneManager.next_board(false)
