class_name CogChain
extends Node2D

@export var cog_rotation: float:
	set(v):
		cog_rotation = v
		rotate_cog(v)


var _first: Cog
var _others: Array[Cog] = []

func rotate_cog(degrees: float) -> void:
	_first.rotation_degrees = degrees
	var dir := -1
	var i := 1
	for cog in _others:
		var a := 180.0 / cog.teeth_count # angle for this cog to fit with previous one
		cog.rotation_degrees = (a * i) + (degrees * (float(_first.teeth_count) / cog.teeth_count)) * dir
		dir = -dir
		i += 1


# Called when the node enters the scene tree for the first time.
func _ready():
	for cog in find_children("*", "Cog", false, true):
		if not _first:
			_first = cog
		else:
			_others.append(cog)
