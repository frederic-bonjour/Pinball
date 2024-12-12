extends Node

var _db: SfxDb
var _compiled: Dictionary
var _active_players: Array = []

class CompiledEntry:
	var filepath: String
	var weight: float
	var type: int


## Sets the SfxDb to use.
func use_db(db: SfxDb) -> void:
	_db = db
	_init_db()


func _init_db() -> void:
	_compiled = {}
	for e in _db.entries:
		if not _compiled.has(e.key):
			_compiled[e.key] = []
		for f in e.files:
			var ce := CompiledEntry.new()
			ce.type = e.type
			ce.filepath = f.file
			for i in range(f.weight):
				_compiled[e.key].append(ce)


func _choose(key: StringName) -> CompiledEntry:
	if _compiled.has(key):
		return (_compiled[key] as Array).pick_random()
	return null

## Plays the sound/music identified by [param key].
func play_at(key: StringName, parent: Node2D) -> AudioStreamPlayer2D:
	var entry := _choose(key)
	if entry:
		var player := AudioStreamPlayer2D.new()
		_active_players.append(player)
		player.stream = load(entry.filepath)
		player.connect(&"finished", _remove_player_2d.bind(player))
		match entry.type:
			0: player.bus = _db.background_music_bus
			1: player.bus = _db.background_sound_bus
			2: player.bus = _db.sound_effet_bus
			3: player.bus = _db.music_effect_bus
		parent.add_child(player)
		player.play()
		return player
	return null

func _remove_player_2d(player: AudioStreamPlayer2D) -> void:
	player.get_parent().remove_child(player)
