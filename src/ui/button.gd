extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	material.set_shader_parameter("hover", true)


func _on_mouse_exited():
	material.set_shader_parameter("hover", false)
