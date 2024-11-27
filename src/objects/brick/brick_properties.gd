@tool
class_name BrickProperties
extends Resource

signal property_changed(prop_name: StringName)

@export var hits: int = 1:
	set(v):
		hits = v
		property_changed.emit(&"hits")

@export var can_be_destroyed_by_ball: bool = true
@export var can_be_destroyed_by_rocket: bool = true

@export_enum(
	"full", "bevel", "cross", "rounded",
	"full empty", "bevel empty", "cross empty", "rounded empty",
	"triangle", "triangle empty", "circle", "circle empty") var shape: int = 0:
	set(v):
		shape = v
		property_changed.emit(&"shape")
