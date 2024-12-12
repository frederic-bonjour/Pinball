@tool
class_name SfxDbEntry
extends Resource

## "Unique" Key.[br]
## Other databases may define the same key to override or add sound files for this key.
@export var key: StringName

## Sound type. Each sound type can be redirected to a dedicated Audio Bus (see [SfxDb]).
@export_enum("background music:0", "background sound:1", "sound effect:2", "music effect:3") var type: int

## The possible sound files for this key.[br]
## Each entry may define a [b]weight[/b] to allow some files to be chosen more/less frequently.
@export var files: Array[SfxDbEntryFile]
@export_group("Volume, Pitch & Distance")
@export_range(-80, 20, 0.5) var volume_db: float = 0.0
@export_range(0.1, 4, 0.1) var pitch_scale: float = 1.0

## Max distance in pixels. 0 means always audible.
@export var max_distance: float = 0.0
@export_exp_easing("attenuation") var attenuation: float = 1.0
