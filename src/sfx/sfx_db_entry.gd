class_name SfxDbEntry
extends Resource

@export var key: StringName
@export_enum("background music:0", "background sound:1", "sound effect:2", "music effect:2") var type: int
@export var files: Array[SfxDbEntryFile]
