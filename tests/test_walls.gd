extends Node2D

@onready var test_polygon: Polygon2D = $TestPolygon

func _on_button_pressed() -> void:
	$Wall._update_collision()
	print_debug($Wall._occluder.occluder.polygon)
	test_polygon.polygon = $Wall._occluder.occluder.polygon
