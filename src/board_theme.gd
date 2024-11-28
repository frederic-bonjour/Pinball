class_name BoardTheme
extends Resource

signal property_changed(prop_name: StringName)

@export_group("Colors")
@export var background_color: Color = Color.ROYAL_BLUE:
	set(v):
		background_color = v
		property_changed.emit(&"background_color")

@export var bricks_color: Color = Color(2, 2, 2, 1):
	set(v):
		bricks_color = v
		property_changed.emit(&"bricks_color")

@export var walls_color: Color = Color.WHITE:
	set(v):
		walls_color = v
		property_changed.emit(&"walls_color")

@export var slingshots_color: Color = Color.WHITE:
	set(v):
		slingshots_color = v
		property_changed.emit(&"slingshots_color")

@export var bumpers_color: Color = Color.WHITE:
	set(v):
		bumpers_color = v
		property_changed.emit(&"bumpers_color")

@export var flippers_color: Color = Color.WHITE:
	set(v):
		flippers_color = v
		property_changed.emit(&"flippers_color")

@export var balls_color: Color =  Color(1, 1, 1, 1):
	set(v):
		balls_color = v
		property_changed.emit(&"balls_color")
