extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var t := create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.tween_property(self, "scale", Vector2(3, 3), 0.8)
	t.parallel().tween_property(self, "modulate:a", 0.0, 0.8)
	t.tween_callback(queue_free)
