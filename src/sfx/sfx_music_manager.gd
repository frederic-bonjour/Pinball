extends Node

var _databases: Dictionary = {}
var _compiled: Dictionary = {}
var _active_players: Array = []


class CompiledEntry:
	var streams: Array[AudioStream] = []
	var streams_weighted := PackedInt32Array()
	var weight: float = 1.0
	var type: int
	var max_distance: float
	var volume_db: float
	var attenuation: float
	var pitch_scale: float
	var db_id: StringName


static func _create_compiled_entry(e: SfxDbEntry, db_id: StringName) -> CompiledEntry:
	var new_entry := CompiledEntry.new()
	new_entry.type = e.type
	new_entry.max_distance = e.max_distance
	new_entry.volume_db = e.volume_db
	new_entry.attenuation = e.attenuation
	new_entry.pitch_scale = e.pitch_scale
	new_entry.db_id = db_id
	new_entry.streams_weighted = PackedInt32Array()
	if e.multiple_streams:
		new_entry.streams = e.weighted_streams.map(func(n): return n.stream)
		for fi in e.files.size():
			for wi in range(e.weighted_streams[fi].weight):
				new_entry.streams_weighted.append(fi)
	else:
		new_entry.streams
		new_entry.streams.append(e.single_stream)
		new_entry.streams_weighted.append(0)
	return new_entry


static func _merge_compiled_entries(dst: CompiledEntry, new_one: CompiledEntry) -> void:
	for i in new_one.streams.size():
		# Is the file already present in the current (dst) entry?
		var idx = dst.streams.find(new_one.streams[i])
		if idx == -1:
			# File not present, so we add it and store its index.
			dst.streams.append(new_one.streams[i])
			idx = dst.streams.size() - 1
		# Adds the values in files_weighted.
		for w in new_one.streams_weighted.count(i):
			dst.streams_weighted.append(idx)


## Adds a SfxDb to use.
## If a database with the same [param db_id] already exists,
## all its entries will first be removed before the new ones are appended,
## no matter the value of [param merge_entries].
## Otherwise, if [param merge_entries] is [code]false[/code], ALL previously added entries
## (coming from other databases) are first removed before the new ones are appended.
## If [param merge_entries] is [code]true[/code], the entries are appended to existing
## ones, enlarging the number of possible sound files for each entry.
func add_db(db_id: StringName, db: SfxDb, merge_entries: bool = true) -> bool:
	if _databases.has(db_id):
		print("Database with ID '%s' already present: it will be removed first." % db_id)
		remove_db(db_id)
	if db:
		_databases[db_id] = db
		print("Adding database...")
		_init_database(db_id, merge_entries)
		return true
	print("'db' is null: no database added.")
	return false


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


func _init_database(db_id: StringName, merge_entries: bool = true) -> void:
	var db = _databases[db_id]
	for e in db.entries:
		var new_entry := _create_compiled_entry(e, db_id)
		if _compiled.has(e.key) and merge_entries:
			_merge_compiled_entries(_compiled[e.key], new_entry)
		else:
			_compiled[e.key] = new_entry


func _choose_stream(entry: CompiledEntry) -> AudioStream:
	var fw = entry.streams_weighted
	return entry.streams[fw[randi() % fw.size()]]


## Plays the sound/music identified by [param key]
## and attaches it to [param parent] for spatial positioning.
func play_at(key: StringName, parent: Node) -> AudioStreamPlayer2D:
	if _compiled.has(key):
		var entry: CompiledEntry = _compiled[key]
		var player := AudioStreamPlayer2D.new()
		_init_player(player, _compiled[key])
		(parent if parent else self).add_child(player)
		player.connect(&"finished", _remove_player_2d.bind(player))
		player.play()
		return player
	return null


## Plays the sound/music identified by [param key].
func play(key: StringName, delay: float = 0.0) -> AudioStreamPlayer:
	if _compiled.has(key):
		var player := AudioStreamPlayer.new()
		_init_player(player, _compiled[key])
		self.add_child(player)
		player.connect(&"finished", _remove_player.bind(player))
		if delay > 0.0:
			await get_tree().create_timer(delay).timeout
		player.play()
		return player
	return null


func _init_player(player: Variant, entry: CompiledEntry) -> void:
	player.stream = _choose_stream(entry)
	var db: SfxDb = _databases[entry.db_id]
	match entry.type:
		0: player.bus = db.background_music_bus
		1: player.bus = db.background_sound_bus
		2: player.bus = db.sound_effect_bus
		3: player.bus = db.music_effect_bus
	player.volume_db = entry.volume_db
	player.pitch_scale = entry.pitch_scale
	if player is AudioStreamPlayer2D:
		player.max_distance = entry.max_distance if entry.max_distance else INF
		player.attenuation = entry.attenuation


func _remove_player_2d(player: AudioStreamPlayer2D) -> void:
	player.get_parent().remove_child(player)


func _remove_player(player: AudioStreamPlayer) -> void:
	remove_child(player)


func print_contents():
	print("# SfxMusicManager's compiled entries:")
	for key in _compiled:
		var entry: CompiledEntry = _compiled[key]
		print("## Key: ", key)
		print(" * type=", entry.type)
		print(" * files=")
		for fi in entry.streams.size():
			print("     - %d: \"%s\" (x%d)" % [fi, entry.streams[fi], entry.streams_weighted.count(fi)])
		print("       weigths=", entry.streams_weighted)
