extends Node

var _databases: Dictionary = {}
var _compiled: Dictionary = {}
var _active_players: Array = []

class CompiledEntry:
	var filepath: String
	var weight: float
	var type: int
	var max_distance: float
	var volume_db: float
	var attenuation: float
	var pitch_scale: float
	var db_id: StringName


## Adds a SfxDb to use.
## If a database with the same [param db_id] already exists,
## all its entries will first be removed before the new ones are appended,
## no matter the value of [param replace].
## Otherwise, if [param replace] is [code]true[/code], ALL previously added entries
## (coming from other databases) are first removed before the new ones are appended.
## If [param replace] is [code]false[/code], the entries are appended to existing
## ones, enlarging the number of possible sound files for each entry.
func add_db(db_id: StringName, db: SfxDb, replace: bool = false) -> void:
	if _databases.has(db_id):
		print("Database with ID '%s' already present: it will be removed first." % db_id)
		remove_db(db_id)
	_databases[db_id] = db
	print("Adding database...")
	_init_database(db_id, replace)


func remove_db(db_id: StringName) -> void:
	var db = _databases[db_id]
	for e in db.entries:
		if _compiled.has(e.key):
			print_debug("Removing existing Entries for %s/%s" % [db_id, e.key])
			for j in range(_compiled[e.key].size() - 1, -1, -1):
				var entry: CompiledEntry = _compiled[e.key][j]
				if entry.db_id == db_id:
					prints("--- removing entry at", j)
					_compiled[e.key].remove_at(j)
			if _compiled[e.key].is_empty():
				_compiled.erase(e.key)
	_databases.erase(db_id)


func clear_databases() -> void:
	_databases.clear()
	_compiled.clear()


func _recompile() -> void:
	_compiled = {}
	for db_id in _databases:
		_init_database(db_id)


func _init_database(db_id: StringName, replace: bool = false) -> void:
	var db = _databases[db_id]
	for e in db.entries:
		if not _compiled.has(e.key):
			print_debug("Creating new Entries for %s/%s" % [db_id, e.key])
			_compiled[e.key] = []
		elif replace:
			print_debug("Replacing existing Entries for %s/%s" % [db_id, e.key])
			_compiled[e.key].clear()
		else:
			print_debug("Removing existing Entries for %s/%s" % [db_id, e.key])
			for j in range(_compiled[e.key].size() - 1, -1, -1):
				var entry: CompiledEntry = _compiled[e.key][j]
				if entry.db_id == db_id:
					prints("--- removing entry at", j)
					_compiled[e.key].remove_at(j)

		print_debug(e.files)
		for f in e.files:
			var ce := CompiledEntry.new()
			ce.type = e.type
			ce.filepath = f.file
			ce.max_distance = e.max_distance
			ce.volume_db = e.volume_db
			ce.attenuation = e.attenuation
			ce.pitch_scale = e.pitch_scale
			ce.db_id = db_id
			for i in range(f.weight):
				_compiled[e.key].append(ce)
	print_debug(_compiled)


func _choose(key: StringName) -> CompiledEntry:
	if _compiled.has(key) and not _compiled[key].is_empty():
		return _compiled[key].pick_random()
	return null


## Plays the sound/music identified by [param key]
## and attaches it to [param parent] for spatial positioning.
func play_at(key: StringName, parent: Node) -> AudioStreamPlayer2D:
	var entry := _choose(key)
	if entry:
		var player := AudioStreamPlayer2D.new()
		(parent if parent else self).add_child(player)
		player.stream = load(entry.filepath)
		player.connect(&"finished", _remove_player_2d.bind(player))
		var db: SfxDb = _databases[entry.db_id]
		match entry.type:
			0: player.bus = db.background_music_bus
			1: player.bus = db.background_sound_bus
			2: player.bus = db.sound_effect_bus
			3: player.bus = db.music_effect_bus
		player.max_distance = entry.max_distance if entry.max_distance else INF
		player.volume_db = entry.volume_db
		player.attenuation = entry.attenuation
		player.pitch_scale = entry.pitch_scale
		player.play()
		return player
	return null


## Plays the sound/music identified by [param key].
func play(key: StringName) -> AudioStreamPlayer:
	var entry := _choose(key)
	if entry:
		var player := AudioStreamPlayer.new()
		self.add_child(player)
		player.stream = load(entry.filepath)
		player.connect(&"finished", _remove_player.bind(player))
		var db: SfxDb = _databases[entry.db_id]
		match entry.type:
			0: player.bus = db.background_music_bus
			1: player.bus = db.background_sound_bus
			2: player.bus = db.sound_effect_bus
			3: player.bus = db.music_effect_bus
		player.volume_db = entry.volume_db
		player.pitch_scale = entry.pitch_scale
		player.play()
		return player
	return null


func _remove_player_2d(player: AudioStreamPlayer2D) -> void:
	player.get_parent().remove_child(player)


func _remove_player(player: AudioStreamPlayer) -> void:
	remove_child(player)
