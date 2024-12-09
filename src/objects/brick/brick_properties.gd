@tool
class_name BrickProperties
extends Resource

signal property_changed(prop_name: StringName)

@export_group("Appearance")
@export_enum(
	"full", "bevel", "cross", "rounded",
	"full empty", "bevel empty", "cross empty", "rounded empty",
	"triangle", "triangle empty", "circle", "circle empty") var shape: int = 0:
	set(v):
		shape = v
		property_changed.emit(&"shape")

@export var scale: Vector2 = Vector2.ONE:
	set(v):
		scale = v
		property_changed.emit(&"scale")

@export var alt_texture: Texture2D:
	set(v):
		alt_texture = v
		notify_property_list_changed()
		property_changed.emit(&"alt_texture")

@export var alt_texture_hframes: int = 1:
	set(v):
		alt_texture_hframes = v
		property_changed.emit(&"alt_texture_hframes")

@export var alt_texture_vframes: int = 1:
	set(v):
		alt_texture_vframes = v
		property_changed.emit(&"alt_texture_vframes")

@export_enum("square", "triangle", "circle") var alt_collision_shape: int = 0:
	set(v):
		alt_collision_shape = v
		property_changed.emit(&"alt_collision_shape")


@export_group("Break")
@export var hits: int = 1:
	set(v):
		hits = v
		property_changed.emit(&"hits")


func _validate_property(property: Dictionary):
	if property.name.begins_with(&"alt_texture_") or property.name == &"alt_collision_shape":
		if alt_texture:
			property.usage |= PROPERTY_USAGE_EDITOR
		else:
			property.usage &= ~PROPERTY_USAGE_EDITOR
