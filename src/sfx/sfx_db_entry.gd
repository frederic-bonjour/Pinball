@tool
@icon("res://src/sfx/sfxdbentry.svg")
class_name SfxDbEntry
extends Resource

## "Unique" Key.[br]
## Other databases may define the same key to override or add sound files for this key.
@export var key: StringName:
	set(v):
		key = v
		_update_resource_name()

## Sound type. Each sound type can be redirected to a dedicated Audio Bus (see [SfxDb]).
@export_enum("background music:0", "background sound:1", "sound effect:2", "music effect:3") var type: int = 2

@export var multiple_streams: bool = false:
	set(v):
		multiple_streams = v
		notify_property_list_changed()
		_update_resource_name()

## A single sound file for this key.
@export var single_stream: AudioStream:
	set(v):
		single_stream = v
		_update_resource_name()

## The possible sound files for this key.[br]
## Each entry must define a [b]weight[/b] to allow some files to be chosen more/less frequently.
@export var weighted_streams: Array[SfxDbEntryStream]:
	set(v):
		weighted_streams = v
		_update_resource_name()

@export_group("Volume, Pitch & Distance")
@export_range(-80, 20, 0.5) var volume_db: float = 0.0
@export_range(0.1, 4, 0.1) var pitch_scale: float = 1.0

## Max distance in pixels. 0 means always audible.
@export var max_distance: float = 0.0
@export_exp_easing("attenuation") var attenuation: float = 1.0


func _validate_property(property):
	if property.name == "weighted_streams":
		property.usage = PROPERTY_USAGE_NO_EDITOR if not multiple_streams else PROPERTY_USAGE_DEFAULT
	if property.name == "single_stream":
		property.usage = PROPERTY_USAGE_NO_EDITOR if multiple_streams else PROPERTY_USAGE_DEFAULT


func _init():
	_update_resource_name()


static func _get_sound_type(type: int) -> StringName:
	match type:
		0: return &"BGM"
		1: return &"BGS"
		2: return &"SE"
		3: return &"ME"
		_: return &"???"


func _update_resource_name() -> void:
	resource_name = "%s (%s, %d)" % [key, _get_sound_type(type), weighted_streams.size() if multiple_streams else 1]
