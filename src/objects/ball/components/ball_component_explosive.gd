class_name BallComponentExplosive
extends BallComponent


var _ray_cast: RayCast2D


func _enter_tree() -> void:
	name = "Explosive"
	_ball = get_parent()
	_ball.connect(&"touched_brick", _on_brick_hit)
	_ray_cast = RayCast2D.new()
	_ray_cast.collision_mask = 16
	_ray_cast.top_level = true
	add_child(_ray_cast)


func _on_brick_hit(brick: Brick, _destroyed: bool) -> void:
	var bricks: Array[Brick] = []
	var steps = 32
	var step = TAU / steps
	_ray_cast.enabled = true
	_ray_cast.global_position = brick.global_position
	for a in range(0, steps):
		_ray_cast.target_position = Vector2.from_angle(step * a) * (60 + 10) # TODO
		_ray_cast.force_raycast_update()
		var blocked = false
		while not blocked and _ray_cast.is_colliding():
			# Get the next object that is colliding.
			var collider = _ray_cast.get_collider()
			if collider is Brick:
				# Add it to the array and to the ray's exceptions.
				bricks.append(collider)
			_ray_cast.add_exception(collider)
			# Update the ray's collision query.
			_ray_cast.force_raycast_update()
	if not bricks.is_empty():
		destroy_bricks(bricks)


func destroy_bricks(bricks):
	for brick in bricks:
		brick.destroy(_ball)
