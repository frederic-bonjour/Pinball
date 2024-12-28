class_name GearBox
extends Node2D

@export var Gear_rotation: float:
	set(v):
		Gear_rotation = v
		rotate_Gear(v)


var _first: Gear
var _others: Array[Gear] = []

func rotate_Gear(degrees: float) -> void:
	_first.rotation_degrees = degrees
	var dir := -1
	var i := 1
	for Gear in _others:
		var a := 180.0 / Gear.teeth_count # angle for this Gear to fit with previous one
		Gear.rotation_degrees = (a * i) + (degrees * (float(_first.teeth_count) / Gear.teeth_count)) * dir
		dir = -dir
		i += 1


# Called when the node enters the scene tree for the first time.
func _ready():
	for Gear in find_children("*", "Gear", false, true):
		if not _first:
			_first = Gear
		else:
			_others.append(Gear)
