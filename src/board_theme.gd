class_name BoardTheme
extends Resource

signal property_changed(prop_name: StringName)

@export_group("Colors")
@export var background_color: Color = Color.ROYAL_BLUE:
	set(v):
		background_color = v
		property_changed.emit(&"background_color")

@export var primary_color: Color = Color.WHITE:
	set(v):
		primary_color = v
		property_changed.emit(&"primary_color")

@export var secondary_color: Color = Color.CYAN:
	set(v):
		secondary_color = v
		property_changed.emit(&"secondary_color")
