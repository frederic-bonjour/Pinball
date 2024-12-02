@tool
class_name Wall
extends AntialiasedLine2D

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

var _body: StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	_body = StaticBody2D.new()
	_body.collision_mask = 2
	add_child(_body)
	_update_collision()


func _update_collision() -> void:
	if not _body: return
	var ps: int = points.size()

	for i in range(ps):
		var radius: float = 0.0
		if i == 0: # first
			radius = start_joint_radius
			if not radius and begin_cap_mode == LineCapMode.LINE_CAP_ROUND:
				radius = width / 2.0
		elif i == ps - 1: # last
			radius = end_joint_radius
			if not radius and end_cap_mode == LineCapMode.LINE_CAP_ROUND:
				radius = width / 2.0
		else: # others = middle
			radius = middle_joints_radius

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
				cs.name = "CSR%d" % i
				cs.shape = RectangleShape2D.new()
				_body.add_child(cs)
			cs.rotation = p1.angle_to_point(p2)
			cs.position = (p1 + p2) / 2.0
			var rs: RectangleShape2D = cs.shape
			rs.size.x = abs(p1 - p2).length()
			rs.size.y = width

	# Remove any other CollisionShape
	for cs in _body.get_children():
		if cs.name.to_int() >= ps:
			_body.remove_child(cs)
			cs.queue_free()


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
