@tool
class_name BrickPropertiesAlt
extends Resource

signal property_changed(prop_name: StringName)

@export var texture: Texture2D:
	set(v):
		texture = v
		notify_property_list_changed()
		property_changed.emit(&"texture")

@export var hframes: int = 1:
	set(v):
		hframes = v
		property_changed.emit(&"hframes")

@export var vframes: int = 1:
	set(v):
		vframes = v
		property_changed.emit(&"vframes")

@export var frame: int = 0:
	set(v):
		frame = v
		property_changed.emit(&"frame")

@export_enum("square", "triangle", "circle") var collision_shape: int = 0:
	set(v):
		collision_shape = v
		property_changed.emit(&"collision_shape")
