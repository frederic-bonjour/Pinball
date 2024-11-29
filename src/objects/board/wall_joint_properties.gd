@tool
class_name WallJointProperties
extends Resource

signal property_changed(prop_name: StringName)

@export var radius: float = 30.0:
	set(v):
		radius = v
		property_changed.emit(&"radius")

@export var hole_radius: float = 0.0:
	set(v):
		hole_radius = v
		property_changed.emit(&"hole_radius")
