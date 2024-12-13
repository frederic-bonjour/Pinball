extends Control

@export var db_global: SfxDb
@export var db_local: SfxDb


# Called when the node enters the scene tree for the first time.
func _ready():
	SfxMusicManager.clear_databases()
	if SfxMusicManager.add_db(&"global", db_global):
		SfxMusicManager.print_contents()
	if SfxMusicManager.add_db(&"local", db_local, false):
		SfxMusicManager.print_contents()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
