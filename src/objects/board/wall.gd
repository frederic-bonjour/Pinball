@tool
class_name Wall
extends AntialiasedLine2D

@warning_ignore("unused_signal")
signal ball_hit


const physics_material = preload("res://src/materials/walls.tres")


@export var start_joint_radius: float = 0.0:
	set(v):
		start_joint_radius = v
		queue_redraw()
		_update_collision()

@export var end_joint_radius: float = 0.0:
	set(v):
		end_joint_radius = v
		queue_redraw()
		_update_collision()

@export var middle_joints_radius: float = 0.0:
	set(v):
		middle_joints_radius = v
		queue_redraw()
		_update_collision()
		

@export_group("Collisions")
@export var start_joint_no_collision: bool = false
@export var middle_joints_no_collision: bool = false
@export var end_joint_no_collision: bool = false

@export var one_way_collision: bool = false:
	set(v):
		one_way_collision = v
		_update_collision()

@export var ball_can_pass_through: bool = false:
	set(v):
		ball_can_pass_through = v
		if _body:
			_body.collision_mask = 0 if ball_can_pass_through else 2
			_body.collision_layer = 0 if ball_can_pass_through else 1


var _body: StaticBody2D
#var _occluder: LightOccluder2D


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	add_to_group(&"walls")

	_body = StaticBody2D.new()
	_body.physics_material_override = physics_material
	add_child(_body)
	ball_can_pass_through = ball_can_pass_through

	#_occluder = LightOccluder2D.new()
	#_occluder.light_mask = 1
	#add_child(_occluder)

	_update_collision()
	round_precision = min(round_precision, 12)
	antialiased = true


func _update_collision() -> void:
	if not _body: return
	var ps: int = points.size()

	for i in range(ps):
		var radius: float = 0.0
		if i == 0: # first
			radius = start_joint_radius if not start_joint_no_collision else 0.0
			if not radius and begin_cap_mode == LineCapMode.LINE_CAP_ROUND:
				radius = width / 2.0
		elif i == ps - 1: # last
			radius = end_joint_radius if not end_joint_no_collision else 0.0
			if not radius and end_cap_mode == LineCapMode.LINE_CAP_ROUND:
				radius = width / 2.0
		else: # others = middle
			radius = middle_joints_radius if not middle_joints_no_collision else 0.0

		var cs: CollisionShape2D
		var p1 = points[i]
		if radius > 0.0:
			cs = get_node_or_null("CSC%d" % i)
			if not cs:
				cs = CollisionShape2D.new()
				cs.name = "CSC%d" % i
				cs.shape = CircleShape2D.new()
				_body.add_child(cs)
			cs.position = p1
			(cs.shape as CircleShape2D).radius = radius

		if i < ps - 1:
			var p2 = points[i + 1]
			cs = get_node_or_null("CSR%d" % i)
			if not cs:
				cs = CollisionShape2D.new()
				cs.one_way_collision = one_way_collision
				cs.name = "CSR%d" % i
				cs.shape = RectangleShape2D.new()
				_body.add_child(cs)
			cs.rotation = p1.angle_to_point(p2)
			cs.position = (p1 + p2) / 2.0
			var rs: RectangleShape2D = cs.shape
			rs.size.x = abs(p1 - p2).length()
			rs.size.y = width

	#_occluder.occluder = OccluderPolygon2D.new()
	#_occluder.occluder.polygon = create_polyline_polygon()

	# Remove any other CollisionShape
	for cs in _body.get_children():
		if cs.name.to_int() >= ps:
			_body.remove_child(cs)
			cs.queue_free()


func create_polyline_polygon() -> PackedVector2Array:
	var polygon_points: PackedVector2Array = PackedVector2Array()
	if points.size() < 2:
		return polygon_points  # Une ligne avec moins de 2 points n'a pas d'épaisseur

	var half_thickness = width / 2
	for i in range(points.size()):
		# Points actuels, précédent et suivant
		var current = points[i]
		var prev: Vector2
		var next: Vector2

		# Calcul des normales
		var normal_prev = Vector2()
		var normal_next = Vector2()

		if i > 0:
			prev = points[i - 1]
			var direction_prev = (current - prev).normalized()
			normal_prev = Vector2(-direction_prev.y, direction_prev.x)

		if i < points.size() - 1:
			next = points[i + 1]
			var direction_next = (next - current).normalized()
			normal_next = Vector2(-direction_next.y, direction_next.x)

		# Gérer les jonctions (angles)
		if prev and next:
			# Moyenne des normales pour la jonction
			var bisector = (normal_prev + normal_next).normalized()
			var miter_length = half_thickness / bisector.dot(normal_prev)
			var corner_outer = current + bisector * miter_length
			var corner_inner = current - bisector * miter_length
			polygon_points.append(corner_outer)
			polygon_points.insert(0, corner_inner)
		else:
			# Pour les extrémités
			if prev:
				polygon_points.append(current + normal_prev * half_thickness)
				polygon_points.insert(0, current - normal_prev * half_thickness)
			elif next:
				polygon_points.append(current + normal_next * half_thickness)
				polygon_points.insert(0, current - normal_next * half_thickness)

	return polygon_points


func _draw() -> void:
	var ps: int = points.size()
	for i in range(ps):
		var radius: float = 0.0
		if i == 0:
			radius = start_joint_radius
		elif i == ps - 1:
			radius = end_joint_radius
		else:
			radius = middle_joints_radius
		if radius > 0.0:
			var p = points[i]
			draw_circle(p, radius, Color.WHITE, true, -1, true)
