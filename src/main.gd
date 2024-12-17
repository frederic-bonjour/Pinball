extends Control


func _ready():
	visible = false
	SfxMusicManager.add_db(&"common", load("res://src/sfxdb_global.tres"))
	SceneManager.nav_home(false)
