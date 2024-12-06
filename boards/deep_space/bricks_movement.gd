extends Node


func _process(_delta: float) -> void:
	var i = 0
	for b in get_parent().find_children("Brick*", "Brick", true, false):
		b.position.y = sin(i + Time.get_ticks_msec() / 400.0) * 5
		i += 1
