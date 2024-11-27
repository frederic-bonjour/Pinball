@tool
class_name WallProperties
extends Resource

signal property_changed(prop_name: StringName)

@export_group("Appearance")
@export var thickness: float = 40.0:
	set(v):
		thickness = v
		property_changed.emit(&"thickness")

@export var length: float = 100.0:
	set(v):
		length = v
		property_changed.emit(&"length")

@export var rounded: bool = true:
	set(v):
		rounded = v
		property_changed.emit(&"rounded")

@export var color: Color = Color.WHITE:
	set(v):
		color = v
		property_changed.emit(&"color")

@export_group("Physics & Collision")
@export var physics_material: PhysicsMaterial:
	set(v):
		physics_material = v
		property_changed.emit(&"physics_material")

@export var collision_rounded: bool = true:
	set(v):
		collision_rounded = v
		property_changed.emit(&"collision_rounded")

@export var adjust_collision_margin: Vector2 = Vector2.ZERO:
	set(v):
		adjust_collision_margin = v
		property_changed.emit(&"adjust_collision_margin")
