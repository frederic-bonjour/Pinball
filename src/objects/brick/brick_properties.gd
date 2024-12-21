@tool
class_name BrickProperties
extends Resource

signal property_changed(prop_name: StringName)

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

@export var hits: int = 1:
	set(v):
		hits = v
		property_changed.emit(&"hits")

"""
func _validate_property(property: Dictionary):
	if property.name.begins_with(&"alt_texture_") or property.name == &"alt_collision_shape":
		if alt_texture:
			property.usage |= PROPERTY_USAGE_EDITOR
		else:
			property.usage &= ~PROPERTY_USAGE_EDITOR
"""
