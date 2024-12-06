@tool
class_name BrickGroupConfigurator
extends Node

#@export var color: Color = Color.WHITE
@export var properties: BrickProperties

# Called when the node enters the scene tree for the first time.
func _ready():
	for b in get_parent().find_children("*", "Brick", true, false):
		#(b as Brick).modulate = Color.WHITE
		if properties:
			(b as Brick).properties = properties
