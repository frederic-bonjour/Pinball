@tool
class_name BrickGroup
extends Node2D


@export var properties: BrickProperties:
	set(v):
		var was_null = not properties and v
		properties = v
		if was_null:
			properties.connect(&"property_changed", _properties_changed)
		_properties_changed()


var bricks: Array[Node]:
	get: return find_children("*", "Brick", true, false)

var is_empty: bool:
	get: return _remaining_bricks == 0

var _remaining_bricks: int


# Called when the node enters the scene tree for the first time.
func _ready():
	connect(&"child_exiting_tree", _on_child_exiting)
	_remaining_bricks = bricks.size()
	_properties_changed()


func _properties_changed(_prop_name = null) -> void:
	for b in bricks:
		if properties:
			(b as Brick).properties = properties


func _on_child_exiting(child: Node) -> void:
	if child is Brick:
		_remaining_bricks -= 1
		if _remaining_bricks == 0:
			SignalHub.brick_group_cleared.emit(self)
