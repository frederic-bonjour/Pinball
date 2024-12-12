@tool
class_name SfxDb
extends Resource

@export var entries: Array[SfxDbEntry]

@export_group("Audio Buses")

## Audio Bus to use for background musics.
@export var background_music_bus: StringName
## Audio Bus to use for background sounds.
@export var background_sound_bus: StringName
## Audio Bus to use for sound effects.
@export var sound_effect_bus: StringName
## Audio Bus to use for music effects.
@export var music_effect_bus: StringName
