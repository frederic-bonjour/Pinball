class_name SfxDbEntryFile
extends Resource

@export_file("*.mp3", "*.wav", "*.ogg") var file: String
@export_range(1, 100) var weight: int = 1
